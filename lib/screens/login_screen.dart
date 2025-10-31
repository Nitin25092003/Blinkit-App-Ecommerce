import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    final ok = _form.currentState!.validate();
    if (!ok) return;
    _form.currentState!.save();
    setState(() { _loading = true; _error = null; });
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(_email.trim(), _password.trim());
    setState(() => _loading = false);
    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      setState(() => _error = 'Invalid credentials. Try signup or check email/password.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          Expanded(
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  const SizedBox(height: 8),
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
                    validator: (v) => v == null || v.length < 4 ? 'Password too short' : null,
                    onSaved: (v) => _password = v ?? '',
                  ),
                  const SizedBox(height: 18),
                  if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.login),
                    label: const Text('Login'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
                  ),
                ],
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Don't have an account?"),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())), child: const Text('Sign up'))
          ])
        ]),
      ),
    );
  }
}
