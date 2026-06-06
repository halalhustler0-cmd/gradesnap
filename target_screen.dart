import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  final _currentCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  double? _needed;
  String _message = '';
  bool _calculated = false;

  void _calculate() {
    final current = double.tryParse(_currentCtrl.text);
    final weight = double.tryParse(_weightCtrl.text);
    final goal = double.tryParse(_goalCtrl.text);
    if (current == null || weight == null || goal == null) {
      setState(() { _calculated = false; });
      return;
    }
    final w = weight / 100;
    final needed = (goal - current * (1 - w)) / w;
    setState(() {
      _calculated = true;
      _needed = needed;
      if (needed > 100) _message = 'Not achievable — try lowering your target.';
      else if (needed < 0) _message = "You've already achieved your goal! 🎉";
      else if (needed >= 90) _message = 'Challenging but possible. Study hard!';
      else if (needed >= 70) _message = 'Achievable with solid preparation.';
      else _message = 'Very achievable — keep it up!';
    });
  }

  void _reset() {
    _currentCtrl.clear(); _weightCtrl.clear(); _goalCtrl.clear();
    setState(() { _calculated = false; _needed = null; _message = ''; });
  }

  Color _resultColor(BuildContext context) {
    if (_needed == null) return Theme.of(context).colorScheme.primary;
    if (_needed! > 100) return Colors.red.shade600;
    if (_needed! < 0) return Colors.green.shade600;
    if (_needed! >= 90) return Colors.orange.shade600;
    return Colors.green.shade600;
  }

  @override
  void dispose() {
    _currentCtrl.dispose(); _weightCtrl.dispose(); _goalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What do I need on my final?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: cs.onSurface)),
          const SizedBox(height: 4),
          Text('Enter your current grade, the weight of the final exam, and your goal.', style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.6))),
          const SizedBox(height: 20),
          _InputField(controller: _currentCtrl, label: 'Current grade (%)', hint: 'e.g. 72', onChanged: (_) => _calculate()),
          const SizedBox(height: 14),
          _InputField(controller: _weightCtrl, label: 'Final exam weight (%)', hint: 'e.g. 40', onChanged: (_) => _calculate()),
          const SizedBox(height: 14),
          _InputField(controller: _goalCtrl, label: 'Grade you want to achieve (%)', hint: 'e.g. 75', onChanged: (_) => _calculate()),
          const SizedBox(height: 20),
          if (_calculated && _needed != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(color: cs.primaryContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text('You need to score on the final', style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.6))),
                  const SizedBox(height: 8),
                  Text(
                    _needed! > 100 ? 'Impossible' : _needed! < 0 ? 'Already done!' : '${_needed!.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600, color: _resultColor(context)),
                  ),
                  const SizedBox(height: 8),
                  Text(_message, style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.7)), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(border: Border.all(color: cs.outline.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _InfoRow('Current grade', '${_currentCtrl.text}%'),
                  _InfoRow('Final exam weight', '${_weightCtrl.text}%'),
                  _InfoRow('Goal grade', '${_goalCtrl.text}%'),
                  _InfoRow('Required final score', _needed! > 100 ? 'N/A' : _needed! < 0 ? 'N/A' : '${_needed!.toStringAsFixed(1)}%', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
            ),
          ],
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: cs.surfaceVariant.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How it works', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.8))),
                const SizedBox(height: 6),
                Text('Formula: Required = (Goal − Current × (1 − Weight)) ÷ Weight\n\nExample: Current 72%, Final worth 40%, Goal 75%\nRequired = (75 − 72 × 0.6) ÷ 0.4 = 79.5%',
                  style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6), height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  const _InputField({required this.controller, required this.label, required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder()),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      onChanged: onChanged,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _InfoRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.6))),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.w600 : FontWeight.w400, color: cs.onSurface)),
        ],
      ),
    );
  }
}
