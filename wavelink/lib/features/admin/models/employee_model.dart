import 'package:flutter/material.dart';

class Employee {
  final String id;
  final String name;
  final String role;
  final String department;
  final String email;
  final String phone;
  final String status;
  final String joinDate;
  final Color avatarColor;

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
}