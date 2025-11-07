import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/constants/app_strings.dart';
import 'package:wavelink/core/utils/navigation_helper.dart';
import 'package:wavelink/features/admin/widgets/kpi_card.dart';
import 'package:wavelink/features/admin/widgets/feature_card.dart';
import 'package:wavelink/features/admin/ai_recommendations_screen.dart';
import 'package:wavelink/features/admin/analytics_dashboard.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 24),
              _buildKPISection(),
              const SizedBox(height: 32),
              _buildFeaturesList(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(AppStrings.adminDashboard),
      backgroundColor: AppColors.navy,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.psychology),
          onPressed: () {
            NavigationHelper.push(context, const AIRecommendationsScreen());
          },
        ),
        IconButton(
          icon: const Icon(Icons.analytics),
          onPressed: () {
            NavigationHelper.push(context, const AnalyticsDashboard());
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      AppStrings.controlCenter,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.navy,
      ),
    );
  }

  Widget _buildKPISection() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: KPICard(
                title: 'Active Terminals',
                value: '12',
                icon: Icons.business,
                color: AppColors.aqua,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: KPICard(
                title: 'Incidents',
                value: '3',
                icon: Icons.warning,
                color: AppColors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(
              child: KPICard(
                title: 'Active Permits',
                value: '48',
                icon: Icons.badge,
                color: AppColors.green,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: KPICard(
                title: 'Maintenance',
                value: '7',
                icon: Icons.build,
                color: AppColors.yellow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return Column(
      children: [
        FeatureCard(
          title: AppStrings.employeeManagement,
          subtitle: 'Add, view, and update employees',
          icon: Icons.people,
          color: AppColors.navy,
          onTap: () {},
        ),
        FeatureCard(
          title: AppStrings.permitDetails,
          subtitle: 'Track active and expired permits',
          icon: Icons.card_membership,
          color: AppColors.aqua,
          onTap: () {},
        ),
        FeatureCard(
          title: AppStrings.certificates,
          subtitle: 'Manage uploaded safety files',
          icon: Icons.verified,
          color: AppColors.green,
          onTap: () {},
        ),
        FeatureCard(
          title: AppStrings.accidentReports,
          subtitle: 'View incidents by severity',
          icon: Icons.report_problem,
          color: AppColors.red,
          onTap: () {},
        ),
        FeatureCard(
          title: AppStrings.maintenanceRepairs,
          subtitle: 'Track ongoing and completed tasks',
          icon: Icons.handyman,
          color: AppColors.yellow,
          onTap: () {},
        ),
        FeatureCard(
          title: AppStrings.feedbackComplaints,
          subtitle: 'View user input and sentiment analytics',
          icon: Icons.feedback,
          color: AppColors.navy,
          onTap: () {},
        ),
        FeatureCard(
          title: AppStrings.emergencyAlerts,
          subtitle: 'Live alerts with response status',
          icon: Icons.emergency,
          color: AppColors.red,
          onTap: () {},
        ),
      ],
    );
  }
}