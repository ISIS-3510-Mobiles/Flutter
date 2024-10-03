class SustainabilityImpact {
  final double moneyRaised;
  final double waterSaved;
  final double wasteDiverted;
  final double co2EmissionsPrevented;

  SustainabilityImpact({
    required this.moneyRaised,
    required this.waterSaved,
    required this.wasteDiverted,
    required this.co2EmissionsPrevented,
  });

  // Create a method to map Firestore data to the model
  factory SustainabilityImpact.fromFirestore(Map<String, dynamic> data) {
    return SustainabilityImpact(
      moneyRaised: data['moneyRaised'] ?? 0.0,
      waterSaved: data['waterSaved'] ?? 0.0,
      wasteDiverted: data['wasteDiverted'] ?? 0.0,
      co2EmissionsPrevented: data['co2EmissionsPrevented'] ?? 0.0,
    );
  }
}
