import 'dart:ffi';

class ProductModel {
  String id;
  String title;
  int price;
  String image;
  double latitude;
  double longitude;
  String description;
  String category;
  bool environmentalImpact;

  // Constructor
  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.category,
    required this.environmentalImpact,
  });

  // Método que convierte de Map a ProductModel
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      price: map['price'] ?? 0,
      image: map['image'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      environmentalImpact: map['environmentalImpact'] ?? false,
    );
  }

  // Método que convierte de ProductModel a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'category': category,
      'environmentalImpact': environmentalImpact,
    };
  }


}
