import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  final List<Product> products;
  const ProductListScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.72),
      itemCount: products.length,
      itemBuilder: (c, i) {
        final p = products[i];
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 3))
            ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: p.image.startsWith('http')
                      ? Image.network(p.image, fit: BoxFit.contain)
                      : Image.asset(p.image, fit: BoxFit.contain),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                  child: Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('\$${p.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
