import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _form = GlobalKey<FormState>();
  String _message = '';
  int _rating = 5;
  bool _sending = false;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanks for the feedback!')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _form,
          child: Column(children: [
            Row(children: [
              const Text('Rating:'),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: _rating,
                items: List.generate(5, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                onChanged: (v) => setState(() => _rating = v ?? 5),
              )
            ]),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Message'),
              minLines: 3,
              maxLines: 5,
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter feedback' : null,
              onSaved: (v) => _message = v ?? '',
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _sending ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
              child: _sending ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Submit'),
            )
          ]),
        ),
      ),
    );
  }
}
