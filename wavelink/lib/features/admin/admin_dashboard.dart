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

  // ===== COUNTS =====
  int _terminalCount = 0;
  int _accidentCount = 0;
  int _repairCount = 0;
  int _certificateCount = 0;

  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadAllCounts();
  }

  // ---------------------------------------------------------------------------
  // FETCH ALL COUNTS FROM SUPABASE
  // ---------------------------------------------------------------------------
  Future<void> _loadAllCounts() async {
    try {
      setState(() => _isLoadingStats = true);

      final supabase = Supabase.instance.client;

      final terminals = await supabase.from('terminals').select('id');
      final accidents = await supabase.from('accidents').select('id');
      final repairs = await supabase.from('repairs').select('id');
      final certificates = await supabase.from('certificates').select('id');

      setState(() {
        _terminalCount = terminals.length;
        _accidentCount = accidents.length;
        _repairCount = repairs.length;
        _certificateCount = certificates.length;
        _isLoadingStats = false;
      });

    } catch (e) {
      print("❌ Error loading dashboard stats: $e");
      setState(() => _isLoadingStats = false);
    }
  }

  // ---------------------------------------------------------------------------
  // LOAD HISTORY NOTIFICATIONS (Simple Format)
  // ---------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> _fetchHistory() async {
  try {
    final supabase = Supabase.instance.client;

    // fetch latest 3 history entries
    final List<dynamic> history = await supabase
        .from('history')
        .select('event_type, logged_by_id, logged_at')
        .order('logged_at', ascending: false)
        .limit(3);

    List<Map<String, dynamic>> finalList = [];

    for (var entry in history) {
      // fetch user email from auth.users
      final user = await supabase
          .from('auth.users')
          .select('email')
          .eq('id', entry['logged_by_id'])
          .maybeSingle();

      final userEmail = user?['email'] ?? "Unknown User";

      finalList.add({
        'event_type': entry['event_type'],
        'user': userEmail,
        'logged_at': entry['logged_at'],
      });
    }

    return finalList;
  } catch (e) {
    print("❌ Error loading history notifications: $e");
    return [];
  }
}


  // ---------------------------------------------------------------------------
  // NOTIFICATION DROPDOWN
  // ---------------------------------------------------------------------------
  void _toggleNotifications(BuildContext context) async {
  if (_notificationOverlay != null) {
    _notificationOverlay!.remove();
    _notificationOverlay = null;
    return;
  }

  final overlay = Overlay.of(context);

  final supabase = Supabase.instance.client;

  List<dynamic> history = [];

  try {
    // Fetch last 3 history logs
    history = await supabase
        .from('history')
        .select('id, event_type, logged_by_id, logged_at')
        .order('logged_at', ascending: false)
        .limit(3);
  } catch (e) {
    print("❌ Error loading history notifications: $e");
  }

  _notificationOverlay = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Close overlay by tapping outside
        GestureDetector(
          onTap: () {
            _notificationOverlay?.remove();
            _notificationOverlay = null;
          },
          child: Container(color: Colors.transparent),
        ),

        Positioned(
          top: kToolbarHeight + 8,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Recent Activity",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (history.isEmpty)
                    const Text("No recent activity",
                        style: TextStyle(color: Colors.white70)),

                  ...history.map((item) => FutureBuilder(
                        future: _fetchUserName(item['logged_by_id']),
                        builder: (context, snapshot) {
                          final userName = snapshot.data ?? "Unknown User";
                          return _buildHistoryTile(item, userName);
                        },
                      )),

                  const Divider(color: Colors.white30),
                  TextButton(
                    onPressed: () {
                      _notificationOverlay?.remove();
                      _notificationOverlay = null;
                    },
                    child: const Text("Close",
                        style: TextStyle(color: AppColors.aqua)),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  overlay.insert(_notificationOverlay!);
}
Future<String> _fetchUserName(String userId) async {
  try {
    final data = await Supabase.instance.client
        .from('users')
        .select('full_name')
        .eq('id', userId)
        .maybeSingle();

    if (data != null && data['full_name'] != null) {
      return data['full_name'];
    }
  } catch (e) {
    print("❌ Error fetching user name: $e");
  }

  return "Unknown User";
}


  // ---------------------------------------------------------------------------
  // HISTORY TILE UI (Simplified)
  // ---------------------------------------------------------------------------
  Widget _buildHistoryTile(dynamic item, String userName) {
  return ListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.history, color: AppColors.aqua, size: 18),
    title: Text(
      item['event_type'] ?? 'Unknown event',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
    subtitle: Text(
      userName,
      style: const TextStyle(color: Colors.white70, fontSize: 11),
    ),
    trailing: Text(
      item['logged_at']?.toString().split('.')[0] ?? "",
      style: const TextStyle(color: Colors.white38, fontSize: 10),
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

      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
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
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AIRecommendationsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.analytics, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AnalyticsDashboardScreen())),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Control Center",
                style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)),

            const SizedBox(height: 24),

            // ===== ROW 1 =====
            Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                      'Active Terminals',
                      _isLoadingStats ? "..." : "$_terminalCount",
                      Icons.business,
                      AppColors.aqua),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKPICard(
                      'Accidents',
                      _isLoadingStats ? "..." : "$_accidentCount",
                      Icons.warning,
                      AppColors.red),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ===== ROW 2 =====
            Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                      'Repairs',
                      _isLoadingStats ? "..." : "$_repairCount",
                      Icons.handyman,
                      AppColors.yellow),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKPICard(
                      'Certificates',
                      _isLoadingStats ? "..." : "$_certificateCount",
                      Icons.verified,
                      AppColors.green),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ===== FEATURE CARDS =====
            _buildFeatureCard(
              '👨‍💼 Employee Management',
              'Add, view and update employees',
              Icons.people,
              AppColors.aqua,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const EmployeeManagementScreen())),
            ),

            _buildFeatureCard(
              '📜 Documents & Reports',
              'Certifications, Repairs & Accident Reports',
              Icons.folder_open,
              AppColors.green,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AdminDocumentsScreen())),
            ),

            // _buildFeatureCard(
            //   '🚨 Emergency Alerts',
            //   'Live alerts with response status',
            //   Icons.emergency,
            //   AppColors.red,
            // ),


          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // KPI CARD WIDGET
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 34, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ]),
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
          child: Row(children: [
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 5),
                Text(subtitle, style: const TextStyle(color: Colors.white70)),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70)
          ]),
        ),
      ),
    );
  }
}
