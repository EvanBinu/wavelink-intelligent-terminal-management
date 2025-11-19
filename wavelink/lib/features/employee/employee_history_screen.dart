import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class EmployeeHistoryScreen extends StatefulWidget {
  const EmployeeHistoryScreen({super.key});

  @override
  State<EmployeeHistoryScreen> createState() => _EmployeeHistoryScreenState();
}

class _EmployeeHistoryScreenState extends State<EmployeeHistoryScreen> {
  final supabase = Supabase.instance.client;

  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  // ---------------------------------------------------------------------------
  // ⭐ FETCH EMPLOYEE HISTORY FROM SUPABASE
  // ---------------------------------------------------------------------------
  Future<List<dynamic>> _fetchHistory() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      print("❌ No logged-in user!");
      return [];
    }

    final response = await supabase
        .from("history")
        .select()
        .eq("employee_id", user.id)
        .order("uploaded_at", ascending: false);

    return response;
  }

  // ---------------------------------------------------------------------------
  // ⭐ UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text(
          'My Upload History',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.aqua),
            );
          }

          final history = snapshot.data!;

          if (history.isEmpty) {
            return const Center(
              child: Text(
                "No history found",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final row = history[index];

              final actionType = row['action_type']; // certificate / repair / accident
              final title = row['action_title'];
              final date = DateTime.parse(row['uploaded_at']);
              final status = row['status'] == true ? "Approved" : "Pending";

              // Color & Icon based on type
              IconData icon;
              Color color;

              switch (actionType) {
                case "certificate":
                  icon = Icons.verified;
                  color = AppColors.green;
                  break;

                case "repair":
                  icon = Icons.build;
                  color = AppColors.aqua;
                  break;

                case "accident":
                  icon = Icons.warning;
                  color = AppColors.red;
                  break;

                default:
                  icon = Icons.file_present;
                  color = AppColors.yellow;
              }

              return Card(
                color: AppColors.navy.withOpacity(0.5),
                shadowColor: color.withOpacity(0.4),
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.8),
                    child: Icon(icon, color: Colors.white),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "$actionType • ${date.toString().split(' ').first}\nStatus: $status",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white54, size: 16),

                  // TODO: Open PDF or detailed history page
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
