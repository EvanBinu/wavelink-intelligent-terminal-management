import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';

// ADMIN SCREENS
import 'package:wavelink/features/admin/employee_management_screen.dart';
import 'package:wavelink/features/admin/admin_documents_screen.dart';
import 'package:wavelink/features/admin/analytics_dashboard.dart';
import 'package:wavelink/features/admin/ai_recommendations_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  OverlayEntry? _notificationOverlay;

  int _terminalCount = 0;
  bool _isTerminalLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTerminalCount();
  }

  // ---------------------------------------------------------------------------
  // FETCH TERMINAL COUNT
  // ---------------------------------------------------------------------------
  Future<void> _fetchTerminalCount() async {
    try {
      final response =
          await Supabase.instance.client.from('terminals').select('id');

      setState(() {
        _terminalCount = (response as List).length;
        _isTerminalLoading = false;
      });
    } catch (e) {
      print("❌ Terminal count error: $e");
      setState(() => _isTerminalLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // NOTIFICATION DROPDOWN
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
                    AppColors.aqua),
                _buildNotificationItem(
                    '🚨 New Alert', 'Emergency signal from Dock 5', AppColors.red),
                _buildNotificationItem(
                    '🧾 Reports', '5 new safety reports submitted', AppColors.green),

                const Divider(color: Colors.white54),
                TextButton(
                  onPressed: () {
                    _notificationOverlay?.remove();
                    _notificationOverlay = null;
                  },
                  child: const Text(
                    'View All Notifications',
                    style: TextStyle(color: AppColors.aqua),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_notificationOverlay!);
  }

  Widget _buildNotificationItem(
      String title, String subtitle, Color color) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withOpacity(0.85),
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
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      // -----------------------------------------------------------------------
      // APP BAR
      // -----------------------------------------------------------------------
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(color: Colors.white)),
        flexibleSpace:
            Container(decoration: const BoxDecoration(gradient: AppColors.headerGradient)),
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
      // MAIN BODY
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // ----------------------------- KPIs ------------------------------
            Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                    'Active Terminals',
                    _isTerminalLoading ? "..." : "$_terminalCount",
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

            // ------------------------ FEATURE CARDS --------------------------
            _buildFeatureCard(
              '👨‍💼 Employee Management',
              'Add, view and update employees',
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
              '📜 Documents & Reports',
              'Certifications, Repairs & Accident Reports',
              Icons.folder_open,
              AppColors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminDocumentsScreen(),
                  ),
                );
              },
            ),

            _buildFeatureCard(
              '🚨 Emergency Alerts',
              'Live alerts with response status',
              Icons.emergency,
              AppColors.red,
            ),

            _buildFeatureCard(
              '🔧 Maintenance & Repairs',
              'Track ongoing and completed tasks',
              Icons.handyman,
              AppColors.yellow,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // KPI CARD
  // ---------------------------------------------------------------------------
  Widget _buildKPICard(
      String title, String value, IconData icon, Color color) {
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
            Icon(icon, color: color, size: 34),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FEATURE CARD
  // ---------------------------------------------------------------------------
  Widget _buildFeatureCard(
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: color.withOpacity(0.4),
      color: AppColors.navy.withOpacity(0.45),
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
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.white70)
            ],
          ),
        ),
      ),
    );
  }
}
