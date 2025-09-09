class PutProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  PutProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory PutProduct.fromJson(Map<String, dynamic> json) {
    return PutProduct(
      id: json['id'],
      title: json['title'],
      price: json['price']?.toDouble() ?? 0.0,
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
  };
}
