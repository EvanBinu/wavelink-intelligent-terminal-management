import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  final supabase = Supabase.instance.client;

  bool _isLoading = true;

  int totalRepairs = 0;
  int totalAccidents = 0;
  int totalCertificates = 0;

  List<dynamic> recentRepairs = [];
  List<dynamic> recentAccidents = [];
  List<dynamic> recentCertificates = [];

  @override
  void initState() {
    super.initState();
    loadAnalytics();
  }

  // ================================================================
  // 🔥 FETCH ANALYTICS FROM SUPABASE
  // ================================================================
  Future<void> loadAnalytics() async {
    try {
      setState(() => _isLoading = true);

      // Count
      final repairsData = await supabase.from('repairs').select('id');
      final accidentsData = await supabase.from('accidents').select('id');
      final certData = await supabase.from('certificates').select('id');

      totalRepairs = repairsData.length;
      totalAccidents = accidentsData.length;
      totalCertificates = certData.length;

      // Recent 5 items
      recentRepairs = await supabase
          .from('repairs')
          .select()
          .order('id', ascending: false)
          .limit(5);

      recentAccidents = await supabase
          .from('accidents')
          .select()
          .order('id', ascending: false)
          .limit(5);

      recentCertificates = await supabase
          .from('certificates')
          .select()
          .order('id', ascending: false)
          .limit(5);

      setState(() => _isLoading = false);
    } catch (e) {
      print("Analytics Error: $e");
      setState(() => _isLoading = false);
    }
  }

  // ================================================================
  // 🔥 UI
  // ================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text("Analytics", style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.aqua))
          : RefreshIndicator(
              onRefresh: loadAnalytics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // =============================
                    // 🔹 CARDS SECTION
                    // =============================
                    Row(
                      children: [
                        Expanded(child: _buildStatCard("Repairs", totalRepairs,
                            Icons.build, Colors.yellow)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard("Accidents", totalAccidents,
                            Icons.warning, Colors.red)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard("Certificates",
                            totalCertificates, Icons.verified, Colors.green)),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // =============================
                    // 🔹 Recent Activity Section
                    // =============================
                    _buildListSection(
                      title: "Recent Repairs",
                      items: recentRepairs,
                      icon: Icons.build,
                    ),
                    const SizedBox(height: 20),

                    _buildListSection(
                      title: "Recent Accidents",
                      items: recentAccidents,
                      icon: Icons.report,
                    ),
                    const SizedBox(height: 20),

                    _buildListSection(
                      title: "Recent Certificates",
                      items: recentCertificates,
                      icon: Icons.verified,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ================================================================
  // 🔹 STAT CARD (Repairs, Accident, Certificate)
  // ================================================================
  Widget _buildStatCard(
      String title, int value, IconData icon, Color highlightColor) {
    return Card(
      color: AppColors.navy.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: highlightColor, size: 30),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style: TextStyle(
                color: highlightColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
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

  // ================================================================
  // 🔹 LIST VIEW SECTION
  // ================================================================
  Widget _buildListSection(
      {required String title,
      required List<dynamic> items,
      required IconData icon}) {
    return Card(
      color: AppColors.navy.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            items.isEmpty
                ? const Text("No records found",
                    style: TextStyle(color: Colors.white54))
                : Column(
                    children: items.map((item) {
                      return ListTile(
                        leading: Icon(icon, color: AppColors.aqua),
                        title: Text(
                          item["title"] ??
                              item["description"] ??
                              "Record #${item['id']}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          item["created_at"] ??
                              item["accident_time"] ??
                              item["reported_at"] ??
                              "",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
