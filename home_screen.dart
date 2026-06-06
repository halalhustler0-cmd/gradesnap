import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'gpa_screen.dart';
import 'target_screen.dart';
import 'cgpa_screen.dart';
import 'predictor_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String theme;
  final Function(String) onThemeChange;
  const HomeScreen({super.key, required this.userName, required this.theme, required this.onThemeChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController _pageCtrl;
  final _titles = ['GPA calculator', 'Target grade', 'CGPA tracker', 'Grade predictor'];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  void _goPage(int p) {
    setState(() => _page = p);
    _pageCtrl.animateToPage(p, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final th = AppTheme.themes[widget.theme] ?? AppTheme.themes['navy']!;
    return Scaffold(
      backgroundColor: th.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              color: th.topbar,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, ${widget.userName} 👋', style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(_titles[_page], style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  // Bare gear icon — no border, no background
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => SettingsScreen(currentTheme: widget.theme, onThemeChange: widget.onThemeChange),
                    )),
                    child: Icon(Icons.settings, color: Colors.white.withOpacity(0.3), size: 20),
                  ),
                ],
              ),
            ),
            // Page dots
            Container(
              color: th.bg,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _page ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _page ? th.accent : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(i == _page ? 3 : 50),
                  ),
                )),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (p) => setState(() => _page = p),
                children: [
                  GPAScreen(theme: th),
                  TargetScreen(theme: th),
                  CGPAScreen(theme: th),
                  PredictorScreen(theme: th),
                ],
              ),
            ),
            // Bottom nav
            Container(
              color: th.topbar,
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _NavItem(icon: Icons.school_rounded, label: 'GPA', active: _page == 0, accent: th.accent, onTap: () => _goPage(0)),
                    _NavItem(icon: Icons.track_changes_rounded, label: 'Target', active: _page == 1, accent: th.accent, onTap: () => _goPage(1)),
                    _NavItem(icon: Icons.show_chart_rounded, label: 'CGPA', active: _page == 2, accent: th.accent, onTap: () => _goPage(2)),
                    _NavItem(icon: Icons.auto_awesome_rounded, label: 'Predictor', active: _page == 3, accent: th.accent, onTap: () => _goPage(3)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color accent;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.active, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: active ? accent : Colors.white.withOpacity(0.25), size: 22),
              const SizedBox(height: 3),
              Text(label, style: TextStyle(color: active ? accent : Colors.white.withOpacity(0.25), fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
