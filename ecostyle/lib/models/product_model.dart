
import 'package:hive_ce_flutter/adapters.dart';


@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int price;

  @HiveField(3)
  String image;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitude;

  @HiveField(6)
  String description;

  @HiveField(7)
  String category;

  @HiveField(8)
  bool environmentalImpact;

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
