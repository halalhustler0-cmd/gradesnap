import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('user_name') ?? '';
  final theme = prefs.getString('theme') ?? 'navy';
  runApp(GradeSnapApp(userName: name, savedTheme: theme));
}

class GradeSnapApp extends StatefulWidget {
  final String userName;
  final String savedTheme;
  const GradeSnapApp({super.key, required this.userName, required this.savedTheme});

  @override
  State<GradeSnapApp> createState() => _GradeSnapAppState();
}

class _GradeSnapAppState extends State<GradeSnapApp> {
  late String _theme;

  @override
  void initState() {
    super.initState();
    _theme = widget.savedTheme;
  }

  void _updateTheme(String t) async {
    setState(() => _theme = t);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', t);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradeSnap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.dark()),
      home: widget.userName.isEmpty
          ? WelcomeScreen(onStart: (name) async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('user_name', name);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (_) => HomeScreen(userName: name, theme: _theme, onThemeChange: _updateTheme),
              ));
            })
          : HomeScreen(userName: widget.userName, theme: _theme, onThemeChange: _updateTheme),
    );
  }
}
