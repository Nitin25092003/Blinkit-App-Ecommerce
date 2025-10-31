import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/products_card.dart';
import 'product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool loading = true;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      products = await ApiService.fetchProductsByCategory(widget.category);
    } catch (_) {
      // fallback to cached DB
      final cached = await ApiService.fetchProducts(); // attempts overall fetch & cache
      products = cached.where((p) => p.category == widget.category).toList();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.category), backgroundColor: Colors.green),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('No products'))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.65),
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          final p = products[i];
          return ProductCard(
            product: p,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
            onAdd: () {
              cart.addToCart(p);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
            },
          );
        },
      ),
    );
  }
}
