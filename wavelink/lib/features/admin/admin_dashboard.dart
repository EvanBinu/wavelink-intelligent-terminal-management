import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/features/admin/ai_recommendations_screen.dart';
import 'package:wavelink/features/admin/analytics_dashboard.dart';
import 'package:wavelink/features/admin/employee_management_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  OverlayEntry? _notificationOverlay;

  // ===== TERMINAL COUNT VARIABLES =====
  int _terminalCount = 0;
  bool _isTerminalLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTerminalCount();
  }

  // ---------------------------------------------------------------------------
  // FETCH TERMINAL COUNT FROM SUPABASE
  // ---------------------------------------------------------------------------
  Future<void> _fetchTerminalCount() async {
    try {
      final response = await Supabase.instance.client
          .from('terminals')
          .select('id');

      setState(() {
        _terminalCount = (response as List).length;
        _isTerminalLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching terminal count: $e");
      setState(() => _isTerminalLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // NOTIFICATION PANEL
  // ---------------------------------------------------------------------------
  void _toggleNotifications(BuildContext context) {
    if (_notificationOverlay != null) {
      _notificationOverlay!.remove();
      _notificationOverlay = null;
      return;
    }

    final overlay = Overlay.of(context);

    _notificationOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight + 8,
        right: 16,
        width: 280,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.navy.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNotificationItem(
                  '⚙ System Check',
                  'Terminal 2 maintenance scheduled',
                  AppColors.aqua,
                ),
                _buildNotificationItem(
                  '🚨 New Alert',
                  'Emergency signal received from Dock 5',
                  AppColors.red,
                ),
                _buildNotificationItem(
                  '🧾 Report Update',
                  '5 new safety reports submitted',
                  AppColors.green,
                ),
                const Divider(color: Colors.white24),
                TextButton(
                  onPressed: () {
                    _notificationOverlay?.remove();
                    _notificationOverlay = null;
                  },
                  child: const Text(
                    'View All Notifications',
                    style: TextStyle(color: AppColors.aqua, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_notificationOverlay!);
  }

  Widget _buildNotificationItem(String title, String subtitle, Color color) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withOpacity(0.8),
        child: const Icon(Icons.notifications, color: Colors.white, size: 16),
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        ),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => _toggleNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.psychology, color: Colors.white),
            tooltip: 'AI Recommendations',
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
            icon: const Icon(Icons.analytics, color: Colors.white),
            tooltip: 'Analytics Dashboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnalyticsDashboardScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // BODY
      // -----------------------------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Control Center',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Row 1 KPIs
            Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                    'Active Terminals',
                    _isTerminalLoading
                        ? "..."
                        : _terminalCount.toString(),
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

            // Row 2 KPIs
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

            // Feature cards
            _buildFeatureCard(
              context,
              '👨‍💼 Employee Management',
              'Add, view, and update employees',
              Icons.people,
              AppColors.aqua,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeManagementScreen(),
                  ),
                );
              },
            ),

            _buildFeatureCard(
              context,
              '🪪 Permit Details',
              'Track active and expired permits',
              Icons.card_membership,
              AppColors.teal,
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
              AppColors.aqua,
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
    );
  }

  // ---------------------------------------------------------------------------
  // KPI CARD WIDGET
  // ---------------------------------------------------------------------------
  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: color.withOpacity(0.5),
      elevation: 6,
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
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FEATURE CARD WIDGET
  // ---------------------------------------------------------------------------
  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
