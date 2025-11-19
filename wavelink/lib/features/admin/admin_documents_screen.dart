// lib/features/admin/admin_documents_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class AdminDocumentsScreen extends StatefulWidget {
  const AdminDocumentsScreen({Key? key}) : super(key: key);

  @override
  State<AdminDocumentsScreen> createState() => _AdminDocumentsScreenState();
}

class _AdminDocumentsScreenState extends State<AdminDocumentsScreen> with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late TabController _tabController;

  List<Map<String, dynamic>> _certificates = [];
  List<Map<String, dynamic>> _repairs = [];
  List<Map<String, dynamic>> _accidents = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() => _loading = true);
    try {
      final certs = await supabase.from('certificates').select().order('uploaded_at', ascending: false);
      final repairs = await supabase.from('repairs').select().order('reported_at', ascending: false);
      final accidents = await supabase.from('accidents').select().order('accident_time', ascending: false);

      setState(() {
        _certificates = List<Map<String,dynamic>>.from(certs ?? []);
        _repairs = List<Map<String,dynamic>>.from(repairs ?? []);
        _accidents = List<Map<String,dynamic>>.from(accidents ?? []);
      });
    } catch (e) {
      debugPrint('Fetch all error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch documents: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _validateEntry({required String table, required String id}) async {
    // Try boolean update first
    try {
      final res = await supabase.from(table).update({'status': true}).eq('id', id);
      // Supabase client returns mapped result; we don't strictly inspect it here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Validated successfully')));
      await _fetchAll();
      return;
    } catch (e) {
      debugPrint('Boolean validate failed, trying string update: $e');
    }

    // Fallback: set string status
    try {
      await supabase.from(table).update({'status': 'validated'}).eq('id', id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Validated (string)')));
      await _fetchAll();
    } catch (e) {
      debugPrint('String validate failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Validate failed: $e')));
    }
  }

  Future<void> _openPdfFromUrl(String url, {String? title}) async {
    // download to temp and open PdfViewerScreen-like widget
    final tempDir = await getTemporaryDirectory();
    final fileName = Uri.parse(url).pathSegments.last;
    final file = File('${tempDir.path}/$fileName');

    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) throw 'HTTP ${resp.statusCode}';
      await file.writeAsBytes(resp.bodyBytes);
      if (!mounted) return;
      await Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerScreen(filePath: file.path, title: title ?? fileName)));
    } catch (e) {
      debugPrint('Open PDF error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to open PDF: $e')));
    }
  }

  String _statusLabel(dynamic status) {
    if (status == null) return 'Unknown';
    if (status is bool) return status ? 'Validated' : 'Pending';
    final s = status.toString().toLowerCase();
    if (s == 'pending') return 'Pending';
    if (s == 'validated' || s == 'true') return 'Validated';
    return status.toString();
  }

  Widget _listTileForRow(String table, Map<String,dynamic> row, {required String title, String? subtitle}) {
    final id = row['id']?.toString() ?? '';
    final fileUrl = (row['file_url'] ?? row['file'] ?? '').toString();
    final status = _statusLabel(row['status']);
    final subtitleText = subtitle ?? (row['employee_name'] ?? row['subject'] ?? row['certificate_name'] ?? '');

    return Card(
      color: AppColors.navy.withOpacity(0.45),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('$subtitleText\nStatus: $status', style: const TextStyle(color: Colors.white70)),
        isThreeLine: true,
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: Colors.white),
            onPressed: fileUrl.isEmpty ? null : () => _openPdfFromUrl(fileUrl, title: title),
            tooltip: 'View PDF',
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
            onPressed: id.isEmpty ? null : () => _confirmValidate(table: table, id: id),
            tooltip: 'Validate',
          ),
        ]),
        onTap: () => fileUrl.isNotEmpty ? _openPdfFromUrl(fileUrl, title: title) : null,
      ),
    );
  }

  Future<void> _confirmValidate({required String table, required String id}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validate entry?'),
        content: const Text('Mark this document/report as validated?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Validate')),
        ],
      ),
    );

    if (confirmed == true) {
      await _validateEntry(table: table, id: id);
    }
  }

  Widget _buildTabView() {
    return TabBarView(controller: _tabController, children: [
      // Certificates
      RefreshIndicator(
        onRefresh: _fetchAll,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.aqua))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _certificates.length,
                itemBuilder: (context, i) {
                  final c = _certificates[i];
                  final name = (c['certificate_name'] ?? c['title'] ?? 'Certificate').toString();
                  final subtitle = (c['employee_name'] ?? c['employee_name'] ?? '').toString();
                  return _listTileForRow('certificates', c, title: name, subtitle: subtitle);
                },
              ),
      ),

      // Repairs
      RefreshIndicator(
        onRefresh: _fetchAll,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.aqua))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _repairs.length,
                itemBuilder: (context, i) {
                  final r = _repairs[i];
                  final title = (r['subject'] ?? r['title'] ?? 'Repair').toString();
                  final subtitle = (r['reported_by_name'] ?? r['employee_name'] ?? r['description'] ?? '').toString();
                  return _listTileForRow('repairs', r, title: title, subtitle: subtitle);
                },
              ),
      ),

      // Accidents
      RefreshIndicator(
        onRefresh: _fetchAll,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.aqua))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _accidents.length,
                itemBuilder: (context, i) {
                  final a = _accidents[i];
                  final title = (a['subject'] ?? a['title'] ?? 'Accident').toString();
                  final subtitle = (a['reported_by_name'] ?? a['employee_name'] ?? a['narrative'] ?? '').toString();
                  return _listTileForRow('accidents', a, title: title, subtitle: subtitle);
                },
              ),
      ),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text('Documents & Reports', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.headerGradient)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.aqua,
          tabs: const [
            Tab(text: 'Certificates'),
            Tab(text: 'Repairs'),
            Tab(text: 'Accidents'),
          ],
        ),
      ),
      body: _buildTabView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.aqua,
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: _fetchAll,
        tooltip: 'Refresh',
      ),
    );
  }
}

/// Simple PDF viewer page (downloaded file path is passed).
class PdfViewerScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const PdfViewerScreen({Key? key, required this.filePath, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.headerGradient)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: PDFView(
            filePath: filePath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            onError: (err) {
              debugPrint('PDFView error: $err');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF error: $err')));
            },
            onPageError: (page, err) {
              debugPrint('PDFView page error: $page -> $err');
            },
          ),
        ),
      ),
    );
  }
}
