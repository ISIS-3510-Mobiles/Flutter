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
    String userId = "temp"; // Retrieve this from your authentication method
    DocumentReference cartRef = _firestore.collection('carts_users').doc(userId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(cartRef);

      if (snapshot.exists) {
        List<dynamic> items = (snapshot.data() as Map<String, dynamic>)['items'] ?? [];
        // Filter out the item with the given itemId
        items = items.where((item) => item['id'] != itemId).toList();

        // Update the cart with the filtered items list
        transaction.update(cartRef, {'items': items});
      }
    });

  }

  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products_temp').add(product.toMap());
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
