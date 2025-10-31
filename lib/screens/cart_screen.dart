import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'payment_screen.dart';
import 'feedback_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), backgroundColor: Colors.green),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final it = cart.items[i];
                return Card(
                  child: ListTile(
                    leading: SizedBox(width: 56, child: Image.network(it.product.image, fit: BoxFit.cover)),
                    title: Text(it.product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('\$${it.product.price.toStringAsFixed(2)} x ${it.quantity}'),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          IconButton(onPressed: () => cart.decrement(it.product.id), icon: const Icon(Icons.remove)),
                          Text(it.quantity.toString()),
                          IconButton(onPressed: () => cart.increment(it.product.id), icon: const Icon(Icons.add)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen()));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
                        child: const Text('Proceed to Payment'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart cleared')));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, padding: const EdgeInsets.all(14)),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
                  },
                  child: const Text('Leave feedback'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
