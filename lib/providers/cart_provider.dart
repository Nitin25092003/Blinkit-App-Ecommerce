import 'package:flutter/material.dart';

import '../models/carts_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {}; // key: product id

  List<CartItem> get items => _items.values.toList();

  int get totalItems => _items.values.fold(0, (s, it) => s + it.quantity);

  double get totalAmount => _items.values.fold(0.0, (s, it) => s + it.subtotal);

  void addToCart(Product p) {
    if (_items.containsKey(p.id)) {
      _items[p.id]!.quantity += 1;
    } else {
      _items[p.id] = CartItem(product: p, quantity: 1);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    if (!_items.containsKey(productId)) return;
    _items.remove(productId);
    notifyListeners();
  }

  void increment(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void decrement(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
