import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/constants/widgets/notification_dropdown.dart';
import 'package:wavelink/features/employee/employee_history_screen.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> employeeData;

  const EmployeeDashboardScreen({
    Key? key,
    required this.employeeData,
  }) : super(key: key);

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  final supabase = Supabase.instance.client;

  // Controllers
  final TextEditingController _certificateTitle = TextEditingController();
  final TextEditingController _repairTitle = TextEditingController();
  final TextEditingController _repairDescription = TextEditingController();
  final TextEditingController _accidentTitle = TextEditingController();
  final TextEditingController _accidentDescription = TextEditingController();

  DateTime? _expiryDate;

  String _repairPriority = "medium";
  String _accidentSeverity = "medium";
  String _involvedParty = "employee";

  // ===========================================================================
  // ⭐ LOG HISTORY (CERTIFICATE, REPAIR, ACCIDENT)
  // ===========================================================================
  Future<void> _logHistory({
    required String eventType,
    required Map<String, dynamic> details,
  }) async {
    final entry = {
      "logged_by_id": widget.employeeData['id'],
      "event_type": eventType,
      "details": details,
      "logged_at": DateTime.now().toIso8601String(),
    };

    try {
      await supabase.from("history").insert(entry);
      print("HISTORY LOGGED → $entry");
    } catch (e) {
      print("❌ HISTORY LOG ERROR: $e");
    }
  }

  // ===========================================================================
  // ⭐ CERTIFICATE DIALOG
  // ===========================================================================
  void _showCertificateUploadDialog() {
    _certificateTitle.clear();
    _expiryDate = null;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.darkBlue,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Upload Certificate",
                    style: TextStyle(color: AppColors.aqua, fontSize: 20)),
                const SizedBox(height: 20),

                TextField(
                  controller: _certificateTitle,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Certificate Title"),
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      builder: (ctx, child) =>
                          Theme(data: ThemeData.dark(), child: child!),
                    );
                    if (picked != null) setState(() => _expiryDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.navy.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          _expiryDate == null
                              ? "Select Expiry Date"
                              : _expiryDate.toString().split(" ").first,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _uploadButton("Upload Certificate", _uploadCertificate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ⭐ REPAIR DIALOG
  // ===========================================================================
  void _showRepairUploadDialog() {
    _repairTitle.clear();
    _repairDescription.clear();
    _repairPriority = "medium";

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.darkBlue,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.70),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Report Repair / Upgrade",
                    style: TextStyle(color: AppColors.aqua, fontSize: 20)),
                const SizedBox(height: 20),

                TextField(
                  controller: _repairTitle,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Repair Subject"),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _repairDescription,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Description"),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _repairPriority,
                  dropdownColor: AppColors.darkBlue,
                  decoration: _inputDecoration("Priority"),
                  items: ["low", "medium", "high"]
                      .map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v.toUpperCase(),
                        style: const TextStyle(color: Colors.white)),
                  ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _repairPriority = v);
                  },
                ),

                const SizedBox(height: 20),
                _uploadButton("Upload Repair Report", _uploadRepair),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ⭐ ACCIDENT DIALOG
  // ===========================================================================
  void _showAccidentUploadDialog() {
    _accidentTitle.clear();
    _accidentDescription.clear();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.darkBlue,
        child: ConstrainedBox(
          constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Report Accident",
                    style: TextStyle(color: AppColors.red, fontSize: 20)),
                const SizedBox(height: 20),

                TextField(
                  controller: _accidentTitle,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Accident Subject"),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _accidentDescription,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Narrative / Description"),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _accidentSeverity,
                  dropdownColor: AppColors.darkBlue,
                  decoration: _inputDecoration("Severity"),
                  items: ["low", "medium", "high"]
                      .map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v.toUpperCase(),
                        style: const TextStyle(color: Colors.white)),
                  ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _accidentSeverity = v);
                  },
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _involvedParty,
                  dropdownColor: AppColors.darkBlue,
                  decoration: _inputDecoration("Involved Party"),
                  items: ["employee", "passenger", "other"]
                      .map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v.toUpperCase(),
                        style: const TextStyle(color: Colors.white)),
                  ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _involvedParty = v);
                  },
                ),

                const SizedBox(height: 20),
                _uploadButton("Upload Accident Report", _uploadAccident),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ⭐ FILE PICKER
  // ===========================================================================
  Future<PlatformFile?> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      return result?.files.single;
    } catch (e) {
      print("File pick error: $e");
      return null;
    }
  }

  // ===========================================================================
  // ⭐ UPLOAD TO SUPABASE STORAGE
  // ===========================================================================
  Future<Map<String, dynamic>> _uploadFileToBucket(PlatformFile picked) async {
    final bytes = await File(picked.path!).readAsBytes();
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${picked.name}";

    await supabase.storage.from("pdfs").uploadBinary(
      fileName,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    final url = await supabase.storage
        .from("pdfs")
        .createSignedUrl(fileName, 60 * 60 * 24 * 365);

    return {"name": fileName, "url": url};
  }

  // ===========================================================================
  // ⭐ CERTIFICATE UPLOAD + HISTORY
  // ===========================================================================
  Future<void> _uploadCertificate() async {
    if (_certificateTitle.text.isEmpty || _expiryDate == null) {
      return _error();
    }

    Navigator.pop(context);

    final picked = await _pickFile();
    if (picked == null) return;

    final file = await _uploadFileToBucket(picked);

    final data = {
      "employee_id": widget.employeeData['id'],
      "certificate_name": _certificateTitle.text.trim(),
      "type": "certificate",
      "file_name": file['name'],
      "file_url": file['url'],
      "expiry_date": _expiryDate!.toIso8601String(),
      "status": "pending",
    };

    try {
      await supabase.from("certificates").insert(data);

      await _logHistory(
        eventType: "certificate",
        details: data,
      );

      _success("Certificate uploaded successfully!");
    } catch (e) {
      _failure("Upload failed: $e");
    }
  }

  // ===========================================================================
  // ⭐ REPAIR UPLOAD + HISTORY
  // ===========================================================================
  Future<void> _uploadRepair() async {
    if (_repairTitle.text.isEmpty || _repairDescription.text.isEmpty) {
      return _error();
    }

    Navigator.pop(context);

    final picked = await _pickFile();
    if (picked == null) return;

    final file = await _uploadFileToBucket(picked);

    final data = {
      "reported_by_id": widget.employeeData['id'],
      "terminal_id": widget.employeeData['terminal_id'],
      "subject": _repairTitle.text.trim(),
      "description": _repairDescription.text.trim(),
      "priority": _repairPriority,
      "status": "pending",
      "reported_at": DateTime.now().toIso8601String(),
      "file_name": file['name'],
      "file_url": file['url'],
    };

    try {
      await supabase.from("repairs").insert(data);

      await _logHistory(
        eventType: "repair",
        details: data,
      );

      _success("Repair report submitted!");
    } catch (e) {
      _failure("Repair upload failed: $e");
    }
  }

  // ===========================================================================
  // ⭐ ACCIDENT UPLOAD + HISTORY
  // ===========================================================================
  Future<void> _uploadAccident() async {
    if (_accidentTitle.text.isEmpty || _accidentDescription.text.isEmpty) {
      return _error();
    }

    Navigator.pop(context);

    final picked = await _pickFile();
    if (picked == null) return;

    final file = await _uploadFileToBucket(picked);

    final data = {
      "reported_by_id": widget.employeeData['id'],
      "terminal_id": widget.employeeData['terminal_id'],
      "accident_time": DateTime.now().toIso8601String(),
      "subject": _accidentTitle.text.trim(),
      "narrative": _accidentDescription.text.trim(),
      "severity": _accidentSeverity,
      "involved_party": _involvedParty,
      "status": "pending",
      "file_name": file['name'],
      "file_url": file['url'],
    };

    try {
      await supabase.from("accidents").insert(data);

      await _logHistory(
        eventType: "accident",
        details: data,
      );

      _success("Accident report submitted!");
    } catch (e) {
      _failure("Accident upload failed: $e");
    }
  }

  // ===========================================================================
  // ⭐ UTILITIES
  // ===========================================================================
  void _error() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields"),
        backgroundColor: AppColors.red,
      ),
    );
  }

  void _success(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.green),
    );
  }

  void _failure(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: AppColors.navy.withOpacity(0.4),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  // ===========================================================================
  // ⭐ UI
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text('Employee Dashboard',
            style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.headerGradient)),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => NotificationDropdown.toggle(
              context,
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmployeeHistoryScreen(
                      employeeData: widget.employeeData,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),

            _buildCard(
              title: "🧱 Report Repair / Upgrade",
              subtitle: "Upload repair report with PDF",
              icon: Icons.build_circle,
              color: AppColors.aqua,
              onTap: _showRepairUploadDialog,
            ),

            _buildCard(
              title: "⚠ Report Accident / Issue",
              subtitle: "Submit accident report with PDF",
              icon: Icons.report,
              color: AppColors.red,
              onTap: _showAccidentUploadDialog,
            ),

            _buildCard(
              title: "📜 Upload Safety Certificates",
              subtitle: "Attach certificate documents",
              icon: Icons.upload_file,
              color: AppColors.green,
              onTap: _showCertificateUploadDialog,
            ),

            _buildCard(
              title: "📊 My Reports / History",
              subtitle: "Your previous reports",
              icon: Icons.history,
              color: AppColors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmployeeHistoryScreen(
                      employeeData: widget.employeeData,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadButton(String text, Function() onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.upload_file, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Function() onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      color: AppColors.navy.withOpacity(0.4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
