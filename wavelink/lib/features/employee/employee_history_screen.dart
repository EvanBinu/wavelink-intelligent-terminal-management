import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class EmployeeHistoryScreen extends StatefulWidget {
  final Map<String, dynamic> employeeData;

  const EmployeeHistoryScreen({
    super.key,
    required this.employeeData,
  });

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

  // -----------------------------------------------
  // FETCH HISTORY based on logged_by_id
  // -----------------------------------------------
  Future<List<dynamic>> _fetchHistory() async {
    final userId = widget.employeeData['id'];

    final response = await supabase
        .from("history")
        .select()
        .eq("logged_by_id", userId)
        .order("logged_at", ascending: false);

    return response;
  }

  // -----------------------------------------------
  // UI
  // -----------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text("My Activity History", style: TextStyle(color: Colors.white)),
        flexibleSpace:
            Container(decoration: const BoxDecoration(gradient: AppColors.headerGradient)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.aqua));
          }

          final history = snapshot.data!;

          if (history.isEmpty) {
            return const Center(
              child: Text("No actions logged", style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final row = history[index];

              final type = row['event_type'];
              final details = row['details'];
              final date = DateTime.parse(row['logged_at']);

              String title = details['title'] ??
                  details['subject'] ??
                  "Untitled";

              IconData icon;
              Color color;

              switch (type) {
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
                  icon = Icons.history;
                  color = AppColors.yellow;
              }

              return Card(
                color: AppColors.navy.withOpacity(0.5),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color,
                    child: Icon(icon, color: Colors.white),
                  ),
                  title: Text(
                    title,
                    style:
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "$type • ${date.toString().split(' ').first}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
