import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Subject {
  String name;
  String grade;
  String credits;
  Subject({this.name = '', this.grade = '', this.credits = ''});
}

class GPAScreen extends StatefulWidget {
  const GPAScreen({super.key});

  @override
  State<GPAScreen> createState() => _GPAScreenState();
}

class _GPAScreenState extends State<GPAScreen> {
  final List<Subject> _subjects = [Subject(), Subject(), Subject()];
  double? _gpa;
  String _letterGrade = '';

  void _calcGPA() {
    double totalPoints = 0;
    double totalCredits = 0;
    for (final s in _subjects) {
      final g = double.tryParse(s.grade);
      final c = double.tryParse(s.credits);
      if (g != null && c != null && c > 0 && g >= 0 && g <= 4) {
        totalPoints += g * c;
        totalCredits += c;
      }
    }
    setState(() {
      if (totalCredits == 0) {
        _gpa = null;
        _letterGrade = '';
      } else {
        _gpa = totalPoints / totalCredits;
        if (_gpa! >= 3.7) _letterGrade = 'A — Distinction';
        else if (_gpa! >= 3.3) _letterGrade = 'A- / B+';
        else if (_gpa! >= 3.0) _letterGrade = 'B — Merit';
        else if (_gpa! >= 2.7) _letterGrade = 'B-';
        else if (_gpa! >= 2.0) _letterGrade = 'C — Pass';
        else if (_gpa! >= 1.0) _letterGrade = 'D — Below average';
        else _letterGrade = 'F — Failing';
      }
    });
  }

  void _addSubject() => setState(() => _subjects.add(Subject()));

  void _removeSubject(int index) {
    setState(() => _subjects.removeAt(index));
    _calcGPA();
  }

  Color _gpaColor(BuildContext context) {
    if (_gpa == null) return Theme.of(context).colorScheme.primary;
    if (_gpa! >= 3.0) return Colors.green.shade600;
    if (_gpa! >= 2.0) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('Your GPA', style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.6))),
                const SizedBox(height: 8),
                Text(
                  _gpa != null ? _gpa!.toStringAsFixed(2) : '—',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600, color: _gpaColor(context)),
                ),
                if (_letterGrade.isNotEmpty)
                  Text(_letterGrade, style: TextStyle(fontSize: 16, color: cs.onSurface.withOpacity(0.6))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Subject', style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.5)))),
                const SizedBox(width: 8),
                SizedBox(width: 80, child: Text('Grade (0–4)', style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.5)), textAlign: TextAlign.center)),
                const SizedBox(width: 8),
                SizedBox(width: 68, child: Text('Credits', style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.5)), textAlign: TextAlign.center)),
                const SizedBox(width: 36),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ...List.generate(_subjects.length, (i) => _SubjectRow(
            subject: _subjects[i],
            onChanged: _calcGPA,
            onDelete: _subjects.length > 1 ? () => _removeSubject(i) : null,
          )),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addSubject,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add subject'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              side: BorderSide(color: cs.outline.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grade scale reference', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.7))),
                const SizedBox(height: 8),
                _scaleRow('A', '4.0'), _scaleRow('A-', '3.7'), _scaleRow('B+', '3.3'),
                _scaleRow('B', '3.0'), _scaleRow('B-', '2.7'), _scaleRow('C+', '2.3'),
                _scaleRow('C', '2.0'), _scaleRow('D', '1.0'), _scaleRow('F', '0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scaleRow(String letter, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 36, child: Text(letter, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Text('→ $points', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }
}

class _SubjectRow extends StatefulWidget {
  final Subject subject;
  final VoidCallback onChanged;
  final VoidCallback? onDelete;
  const _SubjectRow({required this.subject, required this.onChanged, this.onDelete});

  @override
  State<_SubjectRow> createState() => _SubjectRowState();
}

class _SubjectRowState extends State<_SubjectRow> {
  late TextEditingController _nameCtrl;
  late TextEditingController _gradeCtrl;
  late TextEditingController _creditsCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.subject.name);
    _gradeCtrl = TextEditingController(text: widget.subject.grade);
    _creditsCtrl = TextEditingController(text: widget.subject.credits);
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _gradeCtrl.dispose(); _creditsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(flex: 3, child: TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(hintText: 'e.g. Math', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), border: OutlineInputBorder()),
            style: const TextStyle(fontSize: 14),
            onChanged: (v) => widget.subject.name = v,
          )),
          const SizedBox(width: 8),
          SizedBox(width: 80, child: TextField(
            controller: _gradeCtrl,
            decoration: const InputDecoration(hintText: '0–4', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), border: OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            style: const TextStyle(fontSize: 14),
            onChanged: (v) { widget.subject.grade = v; widget.onChanged(); },
          )),
          const SizedBox(width: 8),
          SizedBox(width: 68, child: TextField(
            controller: _creditsCtrl,
            decoration: const InputDecoration(hintText: 'Cr.', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), border: OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            style: const TextStyle(fontSize: 14),
            onChanged: (v) { widget.subject.credits = v; widget.onChanged(); },
          )),
          const SizedBox(width: 4),
          SizedBox(width: 32, child: IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: widget.onDelete,
            padding: EdgeInsets.zero,
            color: widget.onDelete != null ? Theme.of(context).colorScheme.error.withOpacity(0.7) : Colors.transparent,
          )),
        ],
      ),
    );
  }
}
