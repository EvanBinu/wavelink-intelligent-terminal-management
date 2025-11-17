import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/features/admin/models/employee_model.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Admin',
    'Employee',
    'Passenger',
  ];

  List<Employee> _employees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    try {
      final response =
          await Supabase.instance.client.from('users').select('*');

      final List<Employee> loaded = response.map<Employee>((json) {
        return Employee.fromJson(json);
      }).toList();

      setState(() {
        _employees = loaded;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching employees: $e");
      setState(() => _isLoading = false);
    }
  }

  // ----------- FILTERING BASED ON ROLE -------------
  List<Employee> get _filteredEmployees {
    if (_selectedFilter == 'All') return _employees;

    String selected = _selectedFilter.toLowerCase();

    return _employees.where((emp) {
      return emp.role.toLowerCase() == selected;
    }).toList();
  }

  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.darkBlue, AppColors.navy],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildFilterChips(),
                  Expanded(child: _buildEmployeeList()),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.navy,
      title: const Text("Employee Management",
          style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: _showSearchDialog,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final active = _employees.where((e) => e.status == 'Active').length;
    final inactive = _employees.where((e) => e.status == 'Inactive').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.navy, AppColors.aqua]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Team Overview",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _headerStat("Total", _employees.length.toString(),
                  Icons.people),
              _headerStat("Active", active.toString(),
                  Icons.check_circle),
              _headerStat("Inactive", inactive.toString(),
                  Icons.cancel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: _filters.map((filter) {
          final selected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: selected,
              onSelected: (_) =>
                  setState(() => _selectedFilter = filter),
              selectedColor: AppColors.aqua,
              backgroundColor: Colors.white10,
              labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.white70),
              checkmarkColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmployeeList() {
    final employees = _filteredEmployees;

    if (employees.isEmpty) {
      return const Center(
        child:
            Text("No users found", style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      itemBuilder: (context, i) {
        final e = employees[i];
        final bool isActive = e.status.toLowerCase() == "active";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(e.name.isNotEmpty ? e.name[0] : "?",
                      style: const TextStyle(color: Colors.white)),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor:
                        isActive ? Colors.green : Colors.red,
                  ),
                )
              ],
            ),
            title: Text(e.name,
                style: const TextStyle(color: Colors.white)),
            subtitle: Text(
                "${e.role.toUpperCase()} • ${e.department}",
                style: const TextStyle(color: Colors.white70)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white70),
              onPressed: () => _showEmployeeDetails(e),
            ),
          ),
        );
      },
    );
  }

  void _showSearchDialog() {}

  void _showEmployeeDetails(Employee e) {}
}
