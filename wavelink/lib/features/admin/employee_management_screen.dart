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
  
  // Sample employee data
  final List<Employee> _employees = [
    Employee(
      id: 'EMP001',
      name: 'John Smith',
      role: 'Admin',
      department: 'Administration',
      email: 'john.smith@wavelink.com',
      phone: '+1 234 567 8901',
      status: 'Active',
      joinDate: '2022-01-15',
      avatarColor: AppColors.navy,
    ),
    Employee(
      id: 'EMP002',
      name: 'Sarah Johnson',
      role: 'Supervisor',
      department: 'Operations',
      email: 'sarah.j@wavelink.com',
      phone: '+1 234 567 8902',
      status: 'Active',
      joinDate: '2022-03-20',
      avatarColor: AppColors.aqua,
    ),
    Employee(
      id: 'EMP003',
      name: 'Michael Chen',
      role: 'Technician',
      department: 'Maintenance',
      email: 'michael.c@wavelink.com',
      phone: '+1 234 567 8903',
      status: 'Active',
      joinDate: '2022-05-10',
      avatarColor: AppColors.green,
    ),
    Employee(
      id: 'EMP004',
      name: 'Emily Davis',
      role: 'Security',
      department: 'Security',
      email: 'emily.d@wavelink.com',
      phone: '+1 234 567 8904',
      status: 'Active',
      joinDate: '2022-07-01',
      avatarColor: AppColors.red,
    ),
    Employee(
      id: 'EMP005',
      name: 'Robert Wilson',
      role: 'Operator',
      department: 'Terminal Operations',
      email: 'robert.w@wavelink.com',
      phone: '+1 234 567 8905',
      status: 'Active',
      joinDate: '2022-08-15',
      avatarColor: AppColors.yellow,
    ),
    Employee(
      id: 'EMP006',
      name: 'Lisa Anderson',
      role: 'Technician',
      department: 'Maintenance',
      email: 'lisa.a@wavelink.com',
      phone: '+1 234 567 8906',
      status: 'On Leave',
      joinDate: '2022-09-20',
      avatarColor: AppColors.aqua,
    ),
    Employee(
      id: 'EMP007',
      name: 'David Brown',
      role: 'Supervisor',
      department: 'Safety',
      email: 'david.b@wavelink.com',
      phone: '+1 234 567 8907',
      status: 'Active',
      joinDate: '2023-01-10',
      avatarColor: AppColors.navy,
    ),
    Employee(
      id: 'EMP008',
      name: 'Jennifer Lee',
      role: 'Operator',
      department: 'Terminal Operations',
      email: 'jennifer.l@wavelink.com',
      phone: '+1 234 567 8908',
      status: 'Active',
      joinDate: '2023-02-14',
      avatarColor: AppColors.green,
    ),
  ];

  List<Employee> get _filteredEmployees {
    if (_selectedFilter == 'All') {
      return _employees;
    }
    return _employees.where((emp) => emp.role == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterChips(),
        //   _buildStatsCards(),
          Expanded(child: _buildEmployeeList()),
        ],
      ),
      floatingActionButton: _buildAddButton(context),
    );
    
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Employee Management'),
      backgroundColor: AppColors.navy,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSearchDialog(),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {},
        ),
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
        gradient: const LinearGradient(
          colors: [AppColors.aqua, AppColors.navy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.aqua.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.groups,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Overview',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage your workforce',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderStat(
                  'Total',
                  _employees.length.toString(),
                  Icons.people,
                ),
                _buildHeaderDivider(),
                _buildHeaderStat(
                  'Active',
                  activeCount.toString(),
                  Icons.check_circle_outline,
                ),
                _buildHeaderDivider(),
                _buildHeaderStat(
                  'On Leave',
                  onLeaveCount.toString(),
                  Icons.event_busy_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedFilter = filter);
              },
              selectedColor: AppColors.aqua,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCards() {
    final activeCount = _employees.where((e) => e.status == 'Active').length;
    final onLeaveCount = _employees.where((e) => e.status == 'On Leave').length;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Active',
              activeCount.toString(),
              Icons.check_circle,
              AppColors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'On Leave',
              onLeaveCount.toString(),
              Icons.event_busy,
              AppColors.yellow,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Departments',
              '6',
              Icons.business,
              AppColors.aqua,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    final employees = _filteredEmployees;
    
    if (employees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No employees found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return EmployeeCard(
          employee: employees[index],
          onTap: () => _showEmployeeDetails(employees[index]),
          onEdit: () => _editEmployee(employees[index]),
          onDelete: () => _deleteEmployee(employees[index]),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _addNewEmployee(),
      backgroundColor: AppColors.aqua,
      icon: const Icon(Icons.person_add, color: Colors.white),
      label: const Text('Add Employee', style: TextStyle(color: Colors.white)),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Employee'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter name or ID',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
            // Implement search logic
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEmployeeDetails(Employee employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: employee.avatarColor,
                  child: Text(
                    employee.name.split(' ').map((e) => e[0]).join(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.role,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildDetailRow(Icons.badge, 'Employee ID', employee.id),
              _buildDetailRow(Icons.business, 'Department', employee.department),
              _buildDetailRow(Icons.email, 'Email', employee.email),
              _buildDetailRow(Icons.phone, 'Phone', employee.phone),
              _buildDetailRow(Icons.calendar_today, 'Join Date', employee.joinDate),
              _buildDetailRow(
                Icons.circle,
                'Status',
                employee.status,
                statusColor: employee.status == 'Active' ? AppColors.green : AppColors.yellow,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _editEmployee(employee);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.message, color: Colors.white),
                      label: const Text('Contact', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.aqua,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.aqua.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.aqua, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: statusColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNewEmployee() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add employee form would open here')),
    );
  }

  void _editEmployee(Employee employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${employee.name}')),
    );
  }

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to remove ${employee.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${employee.name} removed'),
                  backgroundColor: AppColors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
