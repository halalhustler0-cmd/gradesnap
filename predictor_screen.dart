import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class Component { String name, score, weight; Component({this.name='',this.score='',this.weight=''}); }

class PredictorScreen extends StatefulWidget {
  final GTheme theme;
  const PredictorScreen({super.key, required this.theme});
  @override State<PredictorScreen> createState() => _PredictorScreenState();
}

class _PredictorScreenState extends State<PredictorScreen> {
  final _comps = [Component(name:'Assignments'), Component(name:'Midterm'), Component(name:'Final')];
  double? _pred;
  String _letter = '';

  void _calc() {
    double total = 0, wt = 0;
    for (final c in _comps) {
      final s = double.tryParse(c.score), w = double.tryParse(c.weight);
      if (s != null && w != null && w > 0) { total += s * w / 100; wt += w; }
    }
    setState(() {
      if (wt == 0) { _pred = null; _letter = ''; return; }
      _pred = total / (wt / 100);
      _letter = _pred! >= 90 ? 'A — Excellent' : _pred! >= 80 ? 'B — Good' : _pred! >= 70 ? 'C — Average' : _pred! >= 60 ? 'D — Below average' : 'F — Failing';
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
          Text('PREDICTED FINAL GRADE', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(_pred != null ? '${_pred!.toStringAsFixed(1)}%' : '—', style: TextStyle(color: th.accent, fontSize: 44, fontWeight: FontWeight.w500, letterSpacing: -1)),
          if (_letter.isNotEmpty) Text(_letter, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13)),
        ]),
      ),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: Row(children: [
        Expanded(child: Text('Component', style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 10))),
        SizedBox(width: 70, child: Text('Score %', style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 10), textAlign: TextAlign.center)),
        const SizedBox(width: 6),
        SizedBox(width: 70, child: Text('Weight %', style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 10), textAlign: TextAlign.center)),
        const SizedBox(width: 30),
      ])),
      const SizedBox(height: 6),
      ..._comps.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Expanded(child: _Fi(hint: e.value.name.isEmpty ? 'Name' : e.value.name, onChanged: (v) { e.value.name = v; })),
          const SizedBox(width: 6),
          SizedBox(width: 70, child: _Fi(hint: '0–100', onChanged: (v) { e.value.score = v; _calc(); }, isNum: true)),
          const SizedBox(width: 6),
          SizedBox(width: 70, child: _Fi(hint: '0–100', onChanged: (v) { e.value.weight = v; _calc(); }, isNum: true)),
          const SizedBox(width: 4),
          SizedBox(width: 26, child: _comps.length > 1
              ? IconButton(padding: EdgeInsets.zero, icon: Icon(Icons.close, size: 16, color: Colors.white.withOpacity(0.2)), onPressed: () { setState(() => _comps.removeAt(e.key)); _calc(); })
              : const SizedBox()),
        ]),
      )),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: () => setState(() => _comps.add(Component())),
        child: Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.1)), borderRadius: BorderRadius.circular(10)),
          child: Text('+ Add component', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13)),
        ),
      ),
    ]));
  }
}

class _Fi extends StatelessWidget {
  final String hint; final ValueChanged<String> onChanged; final bool isNum;
  const _Fi({required this.hint, required this.onChanged, this.isNum = false});
  @override Widget build(BuildContext context) => TextField(
    style: const TextStyle(color: Colors.white70, fontSize: 13),
    decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)), isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.2)))),
    keyboardType: isNum ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
    inputFormatters: isNum ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))] : [],
    onChanged: onChanged,
  );
}
