import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class EmployeeHistoryScreen extends StatelessWidget {
  const EmployeeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text(
          'My Reports & SOS History',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildSectionTitle('🧱 Maintenance & Repair Logs'),
            _buildReportTile(
              title: 'Generator Repair Completed',
              date: '03 Nov 2025',
              type: 'Repair Report',
              color: AppColors.aqua,
            ),
            _buildReportTile(
              title: 'Dock Light Replacement',
              date: '29 Oct 2025',
              type: 'Upgrade Report',
              color: AppColors.green,
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('⚠️ Accident / Issue Reports'),
            _buildReportTile(
              title: 'Fuel Leak near Terminal 2',
              date: '22 Oct 2025',
              type: 'Accident Report',
              color: AppColors.red,
            ),
            _buildReportTile(
              title: 'Slip Hazard in Waiting Area',
              date: '12 Oct 2025',
              type: 'Safety Report',
              color: AppColors.yellow,
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('🚨 SOS Alerts Triggered'),
            _buildSosTile('Emergency during loading operation', '08 Sep 2025'),
            _buildSosTile('Passenger fainted onboard', '14 Aug 2025'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildReportTile({
    required String title,
    required String date,
    required String type,
    required Color color,
  }) {
    return Card(
      color: AppColors.navy.withOpacity(0.5),
      shadowColor: color.withOpacity(0.3),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.8),
          child: const Icon(Icons.description, color: Colors.white),
        ),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(
          '$type • $date',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: () {
          // later can open detailed report page
        },
      ),
    );
  }

  Widget _buildSosTile(String description, String date) {
    return Card(
      color: AppColors.red.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.dangerGradient,
            boxShadow: [
              BoxShadow(color: Colors.redAccent, blurRadius: 12, spreadRadius: 2),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'SOS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(description,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Triggered on $date',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
