import 'package:flutter/material.dart';

class SupportMember {
  final String name;
  final String role;
  final String avatar;
  final String phone;
  final Color color;
  final String? avatarPath;

  SupportMember({
    required this.name,
    required this.role,
    required this.avatar,
    required this.phone,
    required this.color,
    this.avatarPath,
  });
}
