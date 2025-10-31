import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(product.title, overflow: TextOverflow.ellipsis), backgroundColor: Colors.green),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(height: 260, child: Image.network(product.image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80))),
          const SizedBox(height: 12),
          Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, color: Colors.green[700], fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(product.description),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              cart.addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14)),
          )
        ],
      ),
    );
  }
}
