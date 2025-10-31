import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    final valid = _form.currentState!.validate();
    if (!valid) return;
    _form.currentState!.save();
    setState(() { _loading = true; _error = null; });
    final user = User(name: _name, email: _email, password: _password, profileImagePath: null);
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.signup(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      setState(() => _error = 'Failed to sign up: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                onSaved: (v) => _email = v ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v == null || v.length < 4 ? 'Too short' : null,
                onSaved: (v) => _password = v ?? '',
              ),
              const SizedBox(height: 18),
              if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton.icon(
                onPressed: _loading ? null : _submit,
                icon: const Icon(Icons.person_add),
                label: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Create account'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
