class Employee {
  final String id;
  final String name;
  final String role;
  final String department;
  final String email;
  final String phone;
  final String status;
  final String joinDate;
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
    required this.avatarColor,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
  final extractedName =
      json['full_name'] ??
      json['employee_name'] ??
      json['name'] ??
      json['username'] ??
      "Unknown";

  final role = (json['role'] ?? 'unknown').toString();

  // ✔ STRICT & CORRECT STATUS CHECK
  bool isActive = false;

  // boolean field
  if (json['is_active'] == true) {
    isActive = true;
  }

  // string-based field
  if (json['status']?.toString().toLowerCase() == "active") {
    isActive = true;
  }

  final statusString = isActive ? "Active" : "Inactive";

  return Employee(
    id: json['id'].toString(),
    name: extractedName,
    role: role,
    department: json['department'] ?? "General",
    email: json['email'] ?? "",
    phone: json['phone'] ?? "",
    status: statusString,
    joinDate: json['join_date'] ?? json['created_at'] ?? "",
    avatarColor: null,
  );
}
}
