import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:ecostyle/models/sustainability_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently authenticated.');
    }
    return user.uid;
  }


  Future<List<ProductModel>> fetchProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<ProductModel>> fetchCartItems() async {
    try {
      // Replace with a method to fetch authenticated user ID
      String userId = "temp"; // Replace with FirebaseAuth.instance.currentUser?.uid
      if (userId.isEmpty) {
        throw Exception("User ID is empty. Please authenticate.");
      }

      // Reference to the user's cart document in Firestore
      DocumentReference cartRef = _firestore.collection('carts_users').doc(userId);

      // Get the cart document snapshot
      DocumentSnapshot cartSnapshot = await cartRef.get();

      // Check if the document exists
      if (!cartSnapshot.exists) {
        debugPrint("Cart document does not exist for userId: $userId");
        return []; // Return an empty list if the cart document doesn't exist
      }

      // Safely cast the data to Map<String, dynamic>
      Map<String, dynamic>? data = cartSnapshot.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('items')) {
        debugPrint("Cart data is null or missing 'items' field for userId: $userId");
        return []; // Return an empty list if the 'items' field is missing
      }

      // Safely extract the list of items
      List<dynamic> items = data['items'];
      if (items is! List) {
        debugPrint("'items' field is not a valid list for userId: $userId");
        return []; // Return an empty list if 'items' is not a valid list
      }

      // Convert the dynamic list to a list of ProductModel
      List<ProductModel> cartItems = items.map((item) {
        try {
          return ProductModel.fromMap(item as Map<String, dynamic>);
        } catch (e) {
          debugPrint("Error parsing cart item: $e");
          return null; // Skip invalid items
        }
      }).whereType<ProductModel>().toList();

      debugPrint("Fetched ${cartItems.length} items for userId: $userId");
      return cartItems;
    } catch (e, stackTrace) {
      // Log the error for debugging purposes
      debugPrint("Error in fetchCartItems: $e\n$stackTrace");
      throw Exception("Failed to fetch cart items. Please try again later.");
    }
  }

  // Remove an item from the cart using the title
  Future<void> removeItemFromCartByTitle(String title) async {
    String userId = "temp"; // Retrieve this from your authentication method
    DocumentReference cartRef = _firestore.collection('carts_users').doc(userId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(cartRef);

      if (snapshot.exists) {
        List<dynamic> items = (snapshot.data() as Map<String, dynamic>)['items'] ?? [];
        // Filter out the item with the given title
        items = items.where((item) => item['title'] != title).toList();

        // Update the cart with the filtered items list
        transaction.update(cartRef, {'items': items});
      }
    });
  }


  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('items').add(product.toMap());
  }

  Future<void> clearCart() async {
    String userId = "temp"; // Retrieve this from your authentication method
    DocumentReference cartRef = _firestore.collection('carts_users').doc(userId);

    // Clear the cart items by setting an empty array
    await cartRef.update({
      'items': []
    });
  }

  Future<void> addImpact(Map<String, dynamic> impactData) async {
    // Calculate impact values based on provided input (you can adjust these calculations as needed)
    double carbonFootprint = _calculateCarbonFootprint(impactData['weight'], impactData['brand']);
    double waterUsage = _calculateWaterUsage(impactData['weight'], impactData['material']);
    double wasteDiverted = _calculateWasteDiverted(impactData['weight']);

    // Prepare the SustainabilityImpactModel to save
    SustainabilityImpactModel impact = SustainabilityImpactModel(
      productId: impactData['item'],
      carbonFootprint: carbonFootprint,
      waterUsage: waterUsage,
      wasteDiverted: wasteDiverted,
    );

    // Save impact to Firestore
    await _firestore.collection('impacts').doc(impact.productId).set(impact.toMap());
  }

  double _calculateCarbonFootprint(double weight, String brand) {
    // Example calculation based on weight and brand
    if (brand == 'Fast Fashion') {
      return weight * 2.0; // Example multiplier
    } else if (brand == 'Local') {
      return weight * 1.0;
    }
    return weight * 1.5; // Default multiplier
  }

  double _calculateWaterUsage(double weight, String material) {
    // Example calculation based on weight and material
    if (material == 'Cotton') {
      return weight * 500; // Example liters per kg
    } else if (material == 'Polyester') {
      return weight * 300;
    }
    return weight * 200; // Default liters per kg
  }

  double _calculateWasteDiverted(double weight) {
    // Example calculation for waste diverted
    return weight * 0.1; // Example, 10% of weight diverted
  }

  Future<List<SustainabilityImpactModel>> fetchAllImpactItems() async {
    final snapshot = await _firestore.collection('impacts').get();
    return snapshot.docs.map((doc) => SustainabilityImpactModel.fromMap(doc.data())).toList();
  }

  Future<void> createOrder(Map<String, dynamic> orderDetails) async {
  try {
    String userId = currentUserId;
    final ordersCollection = FirebaseFirestore.instance.collection('orders');
    await ordersCollection.add(orderDetails);
  } catch (e) {
    throw Exception('Failed to create order: $e');
  }
  }



}
