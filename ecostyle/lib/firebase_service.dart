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
    QuerySnapshot snapshot = await _firestore.collection('cart').get();
    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

// You can add methods for adding items to the cart, etc.
}
