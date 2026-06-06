import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class Semester { String name, gpa, credits; Semester({required this.name, this.gpa='', this.credits=''}); }

class CGPAScreen extends StatefulWidget {
  final GTheme theme;
  const CGPAScreen({super.key, required this.theme});
  @override State<CGPAScreen> createState() => _CGPAScreenState();
}

class _CGPAScreenState extends State<CGPAScreen> {
  final _sems = [Semester(name:'Semester 1'), Semester(name:'Semester 2')];
  double? _cgpa;
  String _letter = '';

  void _calc() {
    double pts = 0, cr = 0;
    for (final s in _sems) {
      final g = double.tryParse(s.gpa), c = double.tryParse(s.credits);
      if (g != null && c != null && c > 0) { pts += g * c; cr += c; }
    }
    setState(() {
      if (cr == 0) { _cgpa = null; _letter = ''; return; }
      _cgpa = pts / cr;
      _letter = _cgpa! >= 3.7 ? 'A — Distinction' : _cgpa! >= 3.0 ? 'B — Merit' : _cgpa! >= 2.0 ? 'C — Pass' : 'Below passing';
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = widget.theme;
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
      Container(
        width: double.infinity, margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(color: th.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.08))),
        child: Column(children: [
          Text('CUMULATIVE GPA', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(_cgpa?.toStringAsFixed(2) ?? '—', style: TextStyle(color: th.accent, fontSize: 44, fontWeight: FontWeight.w500, letterSpacing: -1)),
          if (_letter.isNotEmpty) Text(_letter, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13)),
        ]),
      ),
      ..._sems.asMap().entries.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: th.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.08))),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.value.name, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            SizedBox(width: 100, child: TextField(
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
              decoration: InputDecoration(hintText: 'Credits', hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)), isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), filled: true, fillColor: Colors.white.withOpacity(0.04), border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.white.withOpacity(0.2)))),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              onChanged: (v) { e.value.credits = v; _calc(); },
            )),
          ])),
          SizedBox(width: 80, child: TextField(
            style: TextStyle(color: th.accent, fontSize: 22, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: 'GPA', hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 16), isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), filled: true, fillColor: Colors.white.withOpacity(0.04), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.2)))),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            onChanged: (v) { e.value.gpa = v; _calc(); },
          )),
        ]),
      )),
      GestureDetector(
        onTap: () => setState(() => _sems.add(Semester(name: 'Semester ${_sems.length + 1}'))),
        child: Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.1)), borderRadius: BorderRadius.circular(10)),
          child: Text('+ Add semester', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13)),
        ),
      ),
    ]));
  }
}
