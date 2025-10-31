import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../widgets/category_tile.dart';
import 'category_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [];
  bool loading = true;
  Map<String, String> sampleImageForCategory = {}; // we'll show first product image as preview

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final cats = await ApiService.fetchCategories();
      setState(() => categories = cats);
      // fetch a product for each category to use img preview
      for (final c in cats) {
        try {
          final products = await ApiService.fetchProductsByCategory(c);
          if (products.isNotEmpty) sampleImageForCategory[c] = products.first.image;
        } catch (_) {}
      }
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blinkit Clone'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())), icon: const Icon(Icons.person)),
          Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                icon: const Icon(Icons.shopping_cart),
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    child: Text(cart.totalItems.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                )
            ],
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
            children: [
              Text('Hello, ${auth.user?.name ?? 'Guest'}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Categories', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (ctx, i) {
                  final cat = categories[i];
                  final img = sampleImageForCategory[cat] ?? 'https://placehold.co/200x200';
                  return CategoryTile(title: cat, imageUrl: img, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(category: cat)));
                  });
                },
              ),
              const SizedBox(height: 18),
              const Text('Pull to refresh categories'),
            ],
          ),
        ),
      ),
    );
  }
}
