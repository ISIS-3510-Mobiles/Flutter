class ProductModel {
  String title;
  int price;
  String image;
  double latitude;
  double longitude;
  String description;
  String category;

  // Constructor
  ProductModel({
    required this.title,
    required this.price,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.category,
  });

  // Método que convierte de Map a ProductModel
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      title: map['title'] ?? '',
      price: map['price'] ?? 0,
      image: map['image'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      category: map['category'] ?? '',
    );
  }

  // Método que convierte de ProductModel a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'category': category,
    };
  }


}
