import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/shop/models/cart_model.dart';

class CartService {
  final CollectionReference cartCollection =
  FirebaseFirestore.instance.collection('cartItems');

  // Fetch cart items
  Future<List<CartItemModel>> fetchCartItems() async {
    QuerySnapshot snapshot = await cartCollection.get();
    return snapshot.docs.map((doc) {
      return CartItemModel.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Add a new cart item
  Future<void> addCartItem(CartItemModel item) async {
    await cartCollection.doc(item.id).set(item.toFirestore());
  }

  // Update cart item quantity
  Future<void> updateCartItemQuantity(String id, int quantity) async {
    await cartCollection.doc(id).update({'quantity': quantity});
  }

  // Remove cart item
  Future<void> removeCartItem(String id) async {
    await cartCollection.doc(id).delete();
  }
}
