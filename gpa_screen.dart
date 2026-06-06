import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class Subject { String name, grade, credits; Subject({this.name='',this.grade='',this.credits=''}); }

class GPAScreen extends StatefulWidget {
  final GTheme theme;
  const GPAScreen({super.key, required this.theme});
  @override State<GPAScreen> createState() => _GPAScreenState();
}

class _GPAScreenState extends State<GPAScreen> {
  final _subjects = [Subject(), Subject(), Subject()];
  double? _gpa;
  String _letter = '';

  void _calc() {
    double pts = 0, cr = 0;
    for (final s in _subjects) {
      final g = double.tryParse(s.grade), c = double.tryParse(s.credits);
      if (g != null && c != null && c > 0 && g >= 0 && g <= 4) { pts += g * c; cr += c; }
    }
    setState(() {
      if (cr == 0) { _gpa = null; _letter = ''; return; }
      _gpa = pts / cr;
      _letter = _gpa! >= 3.7 ? 'A — Distinction' : _gpa! >= 3.0 ? 'B — Merit' : _gpa! >= 2.0 ? 'C — Pass' : _gpa! >= 1.0 ? 'D — Below average' : 'F — Failing';
    });
  }

  Color _gpaColor() {
    if (_gpa == null) return widget.theme.accent;
    if (_gpa! >= 3.0) return Colors.green.shade400;
    if (_gpa! >= 2.0) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final th = widget.theme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Container(
          width: double.infinity, margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(color: th.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.08))),
          child: Column(children: [
            Text('YOUR GPA', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, letterSpacing: 0.5)),
            const SizedBox(height: 6),
            Text(_gpa?.toStringAsFixed(2) ?? '—', style: TextStyle(color: _gpaColor(), fontSize: 44, fontWeight: FontWeight.w500, letterSpacing: -1)),
            if (_letter.isNotEmpty) Text(_letter, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13)),
          ]),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: Row(children: [
          Expanded(child: Text('Subject', style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 10))),
          SizedBox(width: 76, child: Text('Grade (0–4)', style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 10), textAlign: TextAlign.center)),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: Text('Credits', style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 10), textAlign: TextAlign.center)),
          const SizedBox(width: 30),
        ])),
        const SizedBox(height: 6),
        ..._subjects.asMap().entries.map((e) => _SubjectRow(
          subject: e.value, onChanged: _calc,
          canDelete: _subjects.length > 1,
          onDelete: () { setState(() => _subjects.removeAt(e.key)); _calc(); },
          th: th,
        )),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => setState(() => _subjects.add(Subject())),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.1)), borderRadius: BorderRadius.circular(10)),
            child: Text('+ Add subject', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13)),
          ),
        ),
      ]),
    );
  }
}

class _SubjectRow extends StatefulWidget {
  final Subject subject; final VoidCallback onChanged, onDelete; final bool canDelete; final GTheme th;
  const _SubjectRow({required this.subject, required this.onChanged, required this.onDelete, required this.canDelete, required this.th});
  @override State<_SubjectRow> createState() => _SubjectRowState();
}
class _SubjectRowState extends State<_SubjectRow> {
  late final _n = TextEditingController(text: widget.subject.name);
  late final _g = TextEditingController(text: widget.subject.grade);
  late final _c = TextEditingController(text: widget.subject.credits);
  @override void dispose() { _n.dispose(); _g.dispose(); _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Expanded(child: _Fi(ctrl: _n, hint: 'e.g. Math', onChanged: (v) { widget.subject.name = v; })),
      const SizedBox(width: 6),
      SizedBox(width: 76, child: _Fi(ctrl: _g, hint: '0–4', onChanged: (v) { widget.subject.grade = v; widget.onChanged(); }, isNum: true)),
      const SizedBox(width: 6),
      SizedBox(width: 60, child: _Fi(ctrl: _c, hint: 'Cr.', onChanged: (v) { widget.subject.credits = v; widget.onChanged(); }, isNum: true)),
      const SizedBox(width: 4),
      SizedBox(width: 26, child: widget.canDelete
          ? IconButton(padding: EdgeInsets.zero, icon: Icon(Icons.close, size: 16, color: Colors.white.withOpacity(0.2)), onPressed: widget.onDelete)
          : const SizedBox()),
    ]),
  );
}

class _Fi extends StatelessWidget {
  final TextEditingController ctrl; final String hint; final ValueChanged<String> onChanged; final bool isNum;
  const _Fi({required this.ctrl, required this.hint, required this.onChanged, this.isNum = false});
  @override Widget build(BuildContext context) => TextField(
    controller: ctrl,
    style: const TextStyle(color: Colors.white70, fontSize: 13),
    decoration: InputDecoration(
      hintText: hint, hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
      isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      filled: true, fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
    ),
    keyboardType: isNum ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
    inputFormatters: isNum ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))] : [],
    onChanged: onChanged,
  );
}
