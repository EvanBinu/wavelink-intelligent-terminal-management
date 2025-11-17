class Employee {
  final String id;
  final String name;
  final String role;
  final String department;
  final String email;
  final String phone;
  final String status;
  final String joinDate;
  final String accountType; // <-- ADDED THIS
  final dynamic avatarColor;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.email,
    required this.phone,
    required this.status,
    required this.joinDate,
    required this.accountType, // <-- ADDED THIS
    required this.avatarColor,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'].toString(),
      name: json['full_name'] ??
          json['employee_name'] ??
          json['username'] ??
          json['name'] ??
          "Unknown",
      role: json['role'] ?? "Unknown",
      department: json['department'] ?? "General",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      status: json['status'] ?? "Inactive",
      joinDate: json['join_date'] ?? "",
      accountType: json['account_type'] ?? "employee", // <-- FIXED
      avatarColor: null,
    );
  }
}
