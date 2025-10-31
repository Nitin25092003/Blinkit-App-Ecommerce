class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromMap(Map<String, dynamic> m) {
    return Product(
      id: (m['id'] as num).toInt(),
      title: (m['title'] ?? '') as String,
      price: (m['price'] as num).toDouble(),
      description: (m['description'] ?? '') as String,
      category: (m['category'] ?? '') as String,
      image: (m['image'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}
