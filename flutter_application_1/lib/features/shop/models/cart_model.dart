class CartItemModel {
  final String id;
  final String name;
  final String color;
  final String size;
  final int quantity;
  final double price;

  CartItemModel({
    required this.id,
    required this.name,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
  });

  // Map Firestore data to CartItemModel
  factory CartItemModel.fromFirestore(Map<String, dynamic> data) {
    return CartItemModel(
      id: data['id'],
      name: data['name'],
      color: data['color'],
      size: data['size'],
      quantity: data['quantity'],
      price: data['price'],
    );
  }

  // Convert CartItemModel to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'size': size,
      'quantity': quantity,
      'price': price,
    };
  }
}
