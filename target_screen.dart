import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class TargetScreen extends StatefulWidget {
  final GTheme theme;
  const TargetScreen({super.key, required this.theme});
  @override State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  final _cur = TextEditingController();
  final _wt = TextEditingController();
  final _goal = TextEditingController();
  double? _needed;
  String _msg = '';
  bool _done = false;

  void _calc() {
    final c = double.tryParse(_cur.text), w = double.tryParse(_wt.text), g = double.tryParse(_goal.text);
    if (c == null || w == null || g == null) { setState(() { _done = false; }); return; }
    final need = (g - c * (1 - w / 100)) / (w / 100);
    setState(() {
      _done = true; _needed = need;
      if (need > 100) _msg = 'Not achievable — try lowering your goal.';
      else if (need < 0) _msg = "You've already achieved your goal! 🎉";
      else if (need >= 90) _msg = 'Challenging — study hard!';
      else _msg = 'Achievable with solid preparation.';
    });
  }

  @override void dispose() { _cur.dispose(); _wt.dispose(); _goal.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final th = widget.theme;
    Color valColor = th.accent;
    if (_needed != null) {
      if (_needed! > 100) valColor = Colors.red.shade400;
      else if (_needed! < 0) valColor = Colors.green.shade400;
      else if (_needed! >= 90) valColor = Colors.orange.shade400;
      else valColor = Colors.green.shade400;
    }
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
      Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(color: th.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.08))),
        child: Column(children: [
          Text('SCORE NEEDED ON FINAL', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(_done && _needed != null ? (_needed! > 100 ? 'N/A' : _needed! < 0 ? 'Done!' : '${_needed!.toStringAsFixed(1)}%') : '—',
            style: TextStyle(color: valColor, fontSize: 44, fontWeight: FontWeight.w500, letterSpacing: -1)),
          if (_done && _msg.isNotEmpty) Text(_msg, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13), textAlign: TextAlign.center),
        ]),
      ),
      _Field(label: 'CURRENT GRADE (%)', hint: 'e.g. 72', ctrl: _cur, onChanged: (_) => _calc()),
      const SizedBox(height: 12),
      _Field(label: 'FINAL EXAM WEIGHT (%)', hint: 'e.g. 40', ctrl: _wt, onChanged: (_) => _calc()),
      const SizedBox(height: 12),
      _Field(label: 'GOAL GRADE (%)', hint: 'e.g. 75', ctrl: _goal, onChanged: (_) => _calc()),
      if (_done) ...[
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: th.topbar, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.06))), child: Column(children: [
          _Row('Current grade', '${_cur.text}%'),
          _Row('Final weight', '${_wt.text}%'),
          _Row('Goal grade', '${_goal.text}%'),
          _Row('Required score', _needed! > 100 || _needed! < 0 ? 'N/A' : '${_needed!.toStringAsFixed(1)}%', bold: true),
        ])),
      ],
    ]));
  }
}

class _Field extends StatelessWidget {
  final String label, hint; final TextEditingController ctrl; final ValueChanged<String> onChanged;
  const _Field({required this.label, required this.hint, required this.ctrl, required this.onChanged});
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, letterSpacing: 0.5)),
    const SizedBox(height: 6),
    TextField(controller: ctrl, style: const TextStyle(color: Colors.white70, fontSize: 15),
      decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white.withOpacity(0.25)))),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      onChanged: onChanged),
  ]);
}

class _Row extends StatelessWidget {
  final String l, v; final bool bold;
  const _Row(this.l, this.v, {this.bold = false});
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(l, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
    Text(v, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
  ]));
}
