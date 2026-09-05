import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF6C5CE7);
  static const primaryDark = Color(0xFF5545C7);

  // Light
  static const lightBackground = Color(0xFFF7F7FB);
  static const lightSurface = Colors.white;
  static const lightText = Color(0xFF1F2937);
  static const lightSecondaryText = Color(0xFF6B7280);
  static const lightBorder = Color(0xFFE5E7EB);

  // Dark
  static const darkBackground = Color(0xFF111318);
  static const darkSurface = Color(0xFF191B21);
  static const darkText = Color(0xFFF9FAFB);
  static const darkSecondaryText = Color(0xFF9CA3AF);
  static const darkBorder = Color(0xFF2A2D35);

  // Status
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
}
