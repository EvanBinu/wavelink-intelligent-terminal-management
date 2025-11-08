import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/features/admin/widgets/employee_card.dart';
import 'package:wavelink/features/admin/models/employee_model.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Admin', 'Supervisor', 'Technician', 'Security', 'Operator'];

  final List<Employee> _employees = [
    Employee(id: 'EMP001', name: 'John Smith', role: 'Admin', department: 'Administration', email: 'john.smith@wavelink.com', phone: '+1 234 567 8901', status: 'Active', joinDate: '2022-01-15', avatarColor: AppColors.aqua),
    Employee(id: 'EMP002', name: 'Sarah Johnson', role: 'Supervisor', department: 'Operations', email: 'sarah.j@wavelink.com', phone: '+1 234 567 8902', status: 'Active', joinDate: '2022-03-20', avatarColor: AppColors.green),
    Employee(id: 'EMP003', name: 'Michael Chen', role: 'Technician', department: 'Maintenance', email: 'michael.c@wavelink.com', phone: '+1 234 567 8903', status: 'Active', joinDate: '2022-05-10', avatarColor: AppColors.teal),
    Employee(id: 'EMP004', name: 'Emily Davis', role: 'Security', department: 'Security', email: 'emily.d@wavelink.com', phone: '+1 234 567 8904', status: 'Active', joinDate: '2022-07-01', avatarColor: AppColors.red),
    Employee(id: 'EMP005', name: 'Robert Wilson', role: 'Operator', department: 'Terminal Ops', email: 'robert.w@wavelink.com', phone: '+1 234 567 8905', status: 'Active', joinDate: '2022-08-15', avatarColor: AppColors.yellow),
  ];

  List<Employee> get _filteredEmployees {
    if (_selectedFilter == 'All') return _employees;
    return _employees.where((emp) => emp.role == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: _buildAppBar(),
      body: Container(
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
      floatingActionButton: _buildAddButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.navy,
      title: const Text("Employee Management", style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: _showSearchDialog),
        IconButton(icon: const Icon(Icons.filter_list, color: Colors.white), onPressed: () {}),
      ],
    );
  }

  Widget _buildHeader() {
    final activeCount = _employees.where((e) => e.status == 'Active').length;
    final onLeaveCount = _employees.where((e) => e.status == 'On Leave').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.navy, AppColors.aqua]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.aqua.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Team Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStat('Total', _employees.length.toString(), Icons.people),
              _buildHeaderStat('Active', activeCount.toString(), Icons.check_circle),
              _buildHeaderStat('On Leave', onLeaveCount.toString(), Icons.event_busy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, i) {
          final filter = _filters[i];
          final selected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: selected,
              onSelected: (_) => setState(() => _selectedFilter = filter),
              selectedColor: AppColors.aqua,
              backgroundColor: Colors.white10,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(color: selected ? Colors.white : Colors.white70),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeList() {
    final employees = _filteredEmployees;
    if (employees.isEmpty) {
      return const Center(child: Text("No employees found", style: TextStyle(color: Colors.white70)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final e = employees[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: e.avatarColor.withOpacity(0.4)),
          ),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: e.avatarColor, child: Text(e.name[0], style: const TextStyle(color: Colors.white))),
            title: Text(e.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('${e.role} • ${e.department}', style: const TextStyle(color: Colors.white70)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white70),
              onPressed: () => _showEmployeeDetails(e),
            ),
          ),
        );
      },
    );
  }

  FloatingActionButton _buildAddButton() {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.aqua,
      onPressed: () {},
      icon: const Icon(Icons.person_add, color: Colors.white),
      label: const Text('Add Employee', style: TextStyle(color: Colors.white)),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        title: const Text("Search Employee", style: TextStyle(color: Colors.white)),
        content: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white12,
            hintText: "Enter name or ID",
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(color: AppColors.aqua),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmployeeDetails(Employee e) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBlue,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, backgroundColor: e.avatarColor, child: Text(e.name[0], style: const TextStyle(fontSize: 28, color: Colors.white))),
            const SizedBox(height: 16),
            Text(e.name, style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
            Text(e.role, style: const TextStyle(color: Colors.white70)),
            const Divider(color: Colors.white24, height: 30),
            _detailRow(Icons.badge, "ID", e.id),
            _detailRow(Icons.email, "Email", e.email),
            _detailRow(Icons.phone, "Phone", e.phone),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.aqua),
              child: const Text("Close", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.aqua, size: 20),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(color: Colors.white70)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
