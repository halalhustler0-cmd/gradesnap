import 'package:flutter/material.dart';

class GTheme {
  final Color bg, topbar, card, accent;
  final String name;
  const GTheme({required this.bg, required this.topbar, required this.card, required this.accent, required this.name});
}

class AppTheme {
  static const themes = {
    'navy': GTheme(bg: Color(0xFF0A1628), topbar: Color(0xFF0D1F3C), card: Color(0xFF0D2040), accent: Color(0xFF4A9EFF), name: 'Deep navy'),
    'purple': GTheme(bg: Color(0xFF120A28), topbar: Color(0xFF1C1040), card: Color(0xFF1A0D3C), accent: Color(0xFFA78BFA), name: 'Purple night'),
    'forest': GTheme(bg: Color(0xFF0A1A10), topbar: Color(0xFF0D2414), card: Color(0xFF0D2818), accent: Color(0xFF4ADE80), name: 'Forest green'),
    'midnight': GTheme(bg: Color(0xFF0A0A0A), topbar: Color(0xFF111111), card: Color(0xFF181818), accent: Color(0xFFE2E8F0), name: 'Pure black'),
  };
}
