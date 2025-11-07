import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/features/admin/ai_recommendations_screen.dart';
import 'package:wavelink/features/admin/analytics_dashboard.dart';
import 'package:wavelink/features/admin/employee_management_screen.dart';
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.psychology),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AIRecommendationsScreen(),
                ),
              );
            },
          ),
          IconButton(
          icon: const Icon(Icons.analytics),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnalyticsDashboardScreen(),
                ),
              );
          },
        ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmployeeManagementScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Control Center',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildKPICard(
                      'Active Terminals',
                      '12',
                      Icons.business,
                      AppColors.aqua,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildKPICard(
                      'Incidents',
                      '3',
                      Icons.warning,
                      AppColors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildKPICard(
                      'Active Permits',
                      '48',
                      Icons.badge,
                      AppColors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildKPICard(
                      'Maintenance',
                      '7',
                      Icons.build,
                      AppColors.yellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildFeatureCard(
                context,
                '👨‍💼 Employee Management',
                'Add, view, and update employees',
                Icons.people,
                AppColors.navy,
              ),
              _buildFeatureCard(
                context,
                '🪪 Permit Details',
                'Track active and expired permits',
                Icons.card_membership,
                AppColors.aqua,
              ),
              _buildFeatureCard(
                context,
                '📜 Certificates',
                'Manage uploaded safety files',
                Icons.verified,
                AppColors.green,
              ),
              _buildFeatureCard(
                context,
                '⚠ Accident Reports',
                'View incidents by severity',
                Icons.report_problem,
                AppColors.red,
              ),
              _buildFeatureCard(
                context,
                '🔧 Maintenance & Repairs',
                'Track ongoing and completed tasks',
                Icons.handyman,
                AppColors.yellow,
              ),
              _buildFeatureCard(
                context,
                '📣 Feedback & Complaints',
                'View user input and sentiment analytics',
                Icons.feedback,
                AppColors.navy,
              ),
              _buildFeatureCard(
                context,
                '🚨 Emergency Alerts',
                'Live alerts with response status',
                Icons.emergency,
                AppColors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskTerminalItem(String terminal, String risk, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              terminal,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Text(
              risk,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}


