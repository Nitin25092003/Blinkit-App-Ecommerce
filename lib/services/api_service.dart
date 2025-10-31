import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'db_helper.dart';

class ApiService {
  static const _base = 'https://fakestoreapi.com';

  static Future<List<String>> fetchCategories() async {
    final url = Uri.parse('$_base/products/categories');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body) as List;
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  static Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$_base/products');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body) as List;
      final products = data.map((e) => Product.fromMap(e as Map<String, dynamic>)).toList();
      // cache
      await DBHelper.insertProductsBatch(products);
      return products;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  static Future<List<Product>> fetchProductsByCategory(String category) async {
    final url = Uri.parse('$_base/products/category/$category');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body) as List;
      final products = data.map((e) => Product.fromMap(e as Map<String, dynamic>)).toList();
      // cache them
      await DBHelper.insertProductsBatch(products);
      return products;
    } else {
      throw Exception('Failed to fetch products by category');
    }
  }
}
