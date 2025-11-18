import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/features/admin/models/employee_model.dart';
import 'package:wavelink/core/utils/password_utils.dart';

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
    'admin',
    'employee',
    'passenger',
  ];

  List<Employee> _employees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  // ---------------- FETCH EMPLOYEES ----------------
  Future<void> _fetchEmployees() async {
    try {
      final response =
          await Supabase.instance.client.from('users').select('*');

      final List<Employee> loaded = (response as List<dynamic>)
          .map<Employee>((json) => Employee.fromJson(json))
          .toList();

      setState(() {
        _employees = loaded;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Fetch error: $e");
      setState(() => _isLoading = false);
    }
  }

  // ---------------- FILTER USERS ----------------
  List<Employee> get _filteredEmployees {
    if (_selectedFilter == 'All') return _employees;

    return _employees.where((emp) =>
        emp.role.toLowerCase() == _selectedFilter.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: _buildAppBar(),
      floatingActionButton: _buildAddEmployeeButton(),
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

  // ---------------- APP BAR ----------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.navy,
      title: const Text(
        "Employee Management",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    final active = _employees.where((e) => e.status == 'active').length;
    final inactive = _employees.where((e) => e.status == 'inactive').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(colors: [AppColors.navy, AppColors.aqua]),
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _headerStat("Total", _employees.length.toString(), Icons.people),
              _headerStat("Active", active.toString(), Icons.check_circle),
              _headerStat("Inactive", inactive.toString(), Icons.cancel),
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
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  // ---------------- FILTER CHIPS ----------------
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
              label: Text(
                filter == 'All'
                    ? 'All'
                    : filter[0].toUpperCase() + filter.substring(1),
                style: TextStyle(
                    color: selected ? Colors.white : Colors.white70),
              ),
              selected: selected,
              onSelected: (_) => setState(() => _selectedFilter = filter),
              selectedColor: AppColors.aqua,
              backgroundColor: Colors.white10,
              checkmarkColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------- EMPLOYEE LIST ----------------
  Widget _buildEmployeeList() {
    final users = _filteredEmployees;

    if (users.isEmpty) {
      return const Center(
        child: Text("No users found", style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, i) {
        final e = users[i];
        final isActive = e.status.toLowerCase() == "active";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    e.name.isNotEmpty ? e.name[0].toUpperCase() : "?",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                      radius: 6,
                      backgroundColor: isActive ? Colors.green : Colors.red),
                )
              ],
            ),
            title: Text(e.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(e.role.toUpperCase(),
                style: const TextStyle(color: Colors.white70)),
          ),
        );
      },
    );
  }

  // ---------------- ADD EMPLOYEE BUTTON ----------------
  Widget _buildAddEmployeeButton() {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.aqua,
      label: const Text("Add Employee", style: TextStyle(color: Colors.white)),
      icon: const Icon(Icons.person_add, color: Colors.white),
      onPressed: _showAddEmployeePopup,
    );
  }

  // ---------------- POPUP FORM FOR ADDING EMPLOYEE ----------------
  void _showAddEmployeePopup() {
    final name = TextEditingController();
    final email = TextEditingController();
    final phone = TextEditingController();
    final department = TextEditingController();
    final password = TextEditingController();
    final confirm = TextEditingController();

    String role = "employee";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Add Employee",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _popupField(name, "Full Name"),
                _popupField(email, "Email"),
                _popupField(phone, "Phone Number"),
                _popupField(department, "Department"),
                _popupField(password, "Password", obscure: true),
                _popupField(confirm, "Confirm Password", obscure: true),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: role,
                  dropdownColor: AppColors.darkBlue,
                  decoration: const InputDecoration(
                    labelText: "Role",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white38)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.aqua)),
                  ),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: "admin", child: Text("Admin")),
                    DropdownMenuItem(value: "employee", child: Text("Employee")),
                    DropdownMenuItem(
                        value: "passenger", child: Text("Passenger")),
                  ],
                  onChanged: (value) => role = value!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.aqua),
              child: const Text("Save"),
              onPressed: () async {
                if (password.text.trim() != confirm.text.trim()) {
                  _showSnack("Passwords do not match", false);
                  return;
                }

                try {
                  final hashed = await hashPassword(password.text.trim());

                  await Supabase.instance.client.from("users").insert({
                    "full_name": name.text.trim(),
                    "email": email.text.trim(),
                    "phone": phone.text.trim(),
                    "role": role,
                    "password": hashed,
                    "is_active": true,

                    "created_at": DateTime.now().toIso8601String(),
                  });

                  Navigator.pop(context);
                  _showSnack("Employee added successfully", true);
                  _fetchEmployees();
                } catch (e) {
                  _showSnack("Insert failed: $e", false);
                }
              },
            )
          ],
        );
      },
    );
  }

  // ---------------- REUSABLE POPUP FIELD ----------------
  Widget _popupField(TextEditingController c, String hint,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          enabledBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.aqua)),
        ),
      ),
    );
  }

  // ---------------- SNACKBAR ----------------
  void _showSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
