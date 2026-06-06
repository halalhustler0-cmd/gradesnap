import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final Function(String) onStart;
  const WelcomeScreen({super.key, required this.onStart});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _ctrl = TextEditingController();
  bool _ready = false;
  bool _loading = false;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _handleStart() async {
    if (!_ready || _loading) return;
    setState(() => _loading = true);
    final name = _ctrl.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    final theme = prefs.getString('theme') ?? 'navy';
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          userName: name,
          theme: theme,
          onThemeChange: (t) async {
            final p = await SharedPreferences.getInstance();
            p.setString('theme', t);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final th = AppTheme.themes['navy']!;
    return Scaffold(
      backgroundColor: th.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: th.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Icon(Icons.school_rounded, color: th.accent, size: 32),
              ),
              const SizedBox(height: 28),
              const Text('GradeSnap', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w500, letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text('GPA calculator, target grade tracker,\nCGPA tracker and grade predictor.', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14, height: 1.6)),
              const SizedBox(height: 40),
              Text('YOUR NAME', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              TextField(
                controller: _ctrl,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'e.g. Alex',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: th.accent)),
                ),
                onChanged: (v) => setState(() => _ready = v.trim().isNotEmpty),
                onSubmitted: (_) => _handleStart(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _ready && !_loading ? _handleStart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: th.accent,
                    disabledBackgroundColor: Colors.white.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Get started', style: TextStyle(color: _ready ? Colors.white : Colors.white.withOpacity(0.3), fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
