import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import '../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _init() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.tryAutoLogin();
    // prefetch categories/products (best-effort)
    try {
      await ApiService.fetchProducts();
      await ApiService.fetchCategories();
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 900));
    if (auth.isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: const Icon(Icons.local_grocery_store, color: Colors.green, size: 72),
          ),
          const SizedBox(height: 18),
          const Text('Blinkit Clone', style: TextStyle(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 12),
          const CircularProgressIndicator(color: Colors.white),
        ]),
      ),
    );
  }
}
