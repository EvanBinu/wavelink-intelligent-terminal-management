import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/constants/widgets/notification_dropdown.dart';
import 'package:wavelink/features/employee/employee_history_screen.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> employeeData;   // ⭐ RECEIVED FROM LOGIN

  const EmployeeDashboardScreen({
    Key? key,
    required this.employeeData,
  }) : super(key: key);

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  final TextEditingController _certificateTitle = TextEditingController();
  DateTime? _expiryDate;

  // ---------------------------------------------------------------------------
  // ⭐ CERTIFICATE UPLOAD DIALOG
  // ---------------------------------------------------------------------------
  void _showCertificateUploadDialog() {
    _certificateTitle.clear();
    _expiryDate = null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Upload Safety Certificate",
                style: TextStyle(
                  color: AppColors.aqua,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _certificateTitle,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Certificate Title",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: AppColors.navy.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    builder: (context, child) =>
                        Theme(data: ThemeData.dark(), child: child!),
                  );

                  if (pickedDate != null) {
                    setState(() => _expiryDate = pickedDate);
                  }
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

              const SizedBox(height: 22),

              ElevatedButton.icon(
                onPressed: _uploadCertificate,
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: const Text("Upload Certificate"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ UPLOAD CERTIFICATE → bucket: pdfs AND table: certificates
  // ---------------------------------------------------------------------------
  Future<void> _uploadCertificate() async {
    if (_certificateTitle.text.trim().isEmpty || _expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter title and expiry date"),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    Navigator.pop(context);

    try {
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (filePickerResult == null) return;

      final filePath = filePickerResult.files.single.path!;
      final bytes = await File(filePath).readAsBytes();

      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${filePickerResult.files.single.name}";

      final supabase = Supabase.instance.client;

      // ⭐ Upload to bucket: pdfs
      await supabase.storage.from("pdfs").uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // ⭐ Signed URL from same bucket
      final signedUrl = await supabase.storage
          .from("pdfs")
          .createSignedUrl(fileName, 60 * 60 * 24 * 365);

      // ⭐ GET EMPLOYEE FROM LOGIN DATA
      final employeeId = widget.employeeData['id'];
      final employeeName = widget.employeeData['name'];

      // ⭐ Insert into certificates table
      final response = await supabase.from("certificates").insert({
        "employee_id": id,
        "employee_name": full_name,
        "title": _certificateTitle.text.trim(),
        "file_name": fileName,
        "file_url": signedUrl,
        "expiry_date": _expiryDate!.toIso8601String(),
      });

      print("INSERT RESPONSE: $response");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Certificate uploaded successfully!"),
          backgroundColor: AppColors.green,
        ),
      );
    } catch (e) {
      print("UPLOAD ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload failed: $e"),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // ⭐ FULL ORIGINAL DASHBOARD UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text('Employee Dashboard', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        ),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => NotificationDropdown.toggle(
              context,
              onViewAll: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EmployeeHistoryScreen()));
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
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            _buildActionCard(
              context,
              '🧱 Report Repair / Upgrade',
              'Log completed maintenance with photos',
              Icons.build_circle,
              AppColors.aqua,
              () => _showReportDialog(context, 'Repair'),
            ),

            _buildActionCard(
              context,
              '⚠ Report Accident / Issue',
              'Submit detailed incident reports',
              Icons.report,
              AppColors.red,
              () => _showReportDialog(context, 'Accident'),
            ),

            _buildActionCard(
              context,
              '📜 Upload Safety Certificates',
              'Attach compliance or safety documents',
              Icons.upload_file,
              AppColors.green,
              () => _showCertificateUploadDialog(),
            ),

            _buildActionCard(
              context,
              '📊 My Reports / History',
              'View your previous submissions and feedback',
              Icons.history,
              AppColors.teal,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployeeHistoryScreen()),
                );
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () => _showEmergencyDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
                icon: const Icon(Icons.emergency, size: 32, color: Colors.white),
                label: const Text(
                  '🚨 TRIGGER EMERGENCY ALERT',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ CARD BUILDER
  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: color.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(color: Colors.grey[300], fontSize: 14)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ REPORT DIALOG
  void _showReportDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.darkBlue.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Report dialog unchanged", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ EMERGENCY DIALOG
  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.darkBlue.withOpacity(0.95),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Text("Emergency dialog unchanged",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
