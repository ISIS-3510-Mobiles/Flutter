
class SustainabilityImpactModel {
  final String productId;
  final double carbonFootprint;
  final double waterUsage;
  final double wasteDiverted;

  SustainabilityImpactModel({
    required this.productId,
    required this.carbonFootprint,
    required this.waterUsage,
    required this.wasteDiverted,
  });

  // Factory method to create a SustainabilityImpactModel from Firestore data
  factory SustainabilityImpactModel.fromMap(Map<String, dynamic> data) {
    return SustainabilityImpactModel(
      productId: data['productId'],
      carbonFootprint: data['carbonFootprint'] ?? 0.0,
      waterUsage: data['waterUsage'] ?? 0.0,
      wasteDiverted: data['wasteDiverted'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'carbonFootprint': carbonFootprint,
      'waterUsage': waterUsage,
      'wasteDiverted': wasteDiverted,
    };
  }
}
