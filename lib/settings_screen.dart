import 'package:flutter/material.dart';
import 'app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final String currentTheme;
  final Function(String) onThemeChange;
  const SettingsScreen({super.key, required this.currentTheme, required this.onThemeChange});
  @override State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selected;
  @override void initState() { super.initState(); _selected = widget.currentTheme; }

  @override
  Widget build(BuildContext context) {
    final th = AppTheme.themes[_selected] ?? AppTheme.themes['navy']!;
    return Scaffold(
      backgroundColor: th.bg,
      appBar: AppBar(
        backgroundColor: th.topbar,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('COLOR THEME', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true, crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.4,
            children: AppTheme.themes.entries.map((e) {
              final t = e.value;
              final selected = _selected == e.key;
              return GestureDetector(
                onTap: () { setState(() => _selected = e.key); widget.onThemeChange(e.key); },
                child: Container(
                  decoration: BoxDecoration(
                    color: t.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? t.accent : Colors.white.withOpacity(0.08), width: selected ? 2 : 0.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(width: 24, height: 24, decoration: BoxDecoration(color: t.accent, borderRadius: BorderRadius.circular(6))),
                      if (selected) Icon(Icons.check_circle_rounded, color: t.accent, size: 18),
                    ]),
                    const Spacer(),
                    Text(t.name, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                  ]),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }
}
