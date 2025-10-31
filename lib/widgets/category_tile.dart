import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.title, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 6)],
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 36, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
