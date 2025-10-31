import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onTap, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(product.image, fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
