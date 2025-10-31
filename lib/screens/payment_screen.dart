import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool processing = false;
  final _form = GlobalKey<FormState>();
  String _name = '';
  String _card = '';

  Future<void> _pay() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    setState(() => processing = true);
    // simulate payment processing
    await Future.delayed(const Duration(seconds: 2));
    setState(() => processing = false);
    // In demo, clear cart
    Provider.of<CartProvider>(context, listen: false).clear();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Thank you for your purchase!'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = Provider.of<CartProvider>(context).totalAmount;
    return Scaffold(
      appBar: AppBar(title: const Text('Payment'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          Text('Total to pay: \$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Form(
            key: _form,
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name on card'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card number'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.length < 12 ? 'Enter card number' : null,
                onSaved: (v) => _card = v ?? '',
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: processing ? null : _pay,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
                child: processing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Pay now'),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
