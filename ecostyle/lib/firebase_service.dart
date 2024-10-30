import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecostyle/models/product_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<ProductModel>> fetchCartItems() async {
    String userId = "temp"; // Retrieve this from your authentication method
    DocumentReference cartRef = FirebaseFirestore.instance.collection('carts_users')
        .doc(userId);

    // Get the cart document
    DocumentSnapshot cartSnapshot = await cartRef.get();

    // Check if the document exists
    if (cartSnapshot.exists) {
      // Safely cast the data to Map<String, dynamic>
      Map<String, dynamic> data = cartSnapshot.data() as Map<String, dynamic>;

      // Get the list of items from the document
      List<dynamic> items = data['items'] ?? [];

      // Convert the dynamic list to a list of ProductModel
      List<ProductModel> cartItems = items.map((item) => ProductModel.fromMap(item)).toList();

      return cartItems;
    } else {
      return []; // Return an empty list if the cart doesn't exist
    }
  }


  // Remove an item from the cart
  Future<void> removeItemFromCart(String itemId) async {
    try {
      await _firestore.collection('cart').doc(itemId).delete();
    } catch (e) {
      throw e; // Handle error as needed
    }
  }

  Future<void> clearCart() async {
    String userId = "temp"; // Retrieve this from your authentication method
    DocumentReference cartRef = FirebaseFirestore.instance.collection('carts_users').doc(userId);

    // Clear the cart items by setting an empty array
    await cartRef.update({
      'items': []
    });
  }
}
