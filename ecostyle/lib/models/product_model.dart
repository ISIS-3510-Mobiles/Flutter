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

  // New fields
  @HiveField(9)
  double carbonFootprint;

  @HiveField(10)
  double wasteDiverted;

  @HiveField(11)
  double sustainabilityPercentage;

  @HiveField(12)
  double waterUsage;

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
    required this.carbonFootprint,
    required this.wasteDiverted,
    required this.sustainabilityPercentage,
    required this.waterUsage,
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
      carbonFootprint: map['carbonFootprint']?.toDouble() ?? 0.0,
      wasteDiverted: map['wasteDiverted']?.toDouble() ?? 0.0,
      sustainabilityPercentage: map['sustainabilityPercentage']?.toDouble() ?? 0.0,
      waterUsage: map['waterUsage']?.toDouble() ?? 0.0,
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
      'carbonFootprint': carbonFootprint,
      'wasteDiverted': wasteDiverted,
      'sustainabilityPercentage': sustainabilityPercentage,
      'waterUsage': waterUsage,
    };
  }
}
