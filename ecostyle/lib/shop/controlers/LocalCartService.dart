import 'package:ecostyle/models/product_model.dart';
import 'package:hive_ce_flutter/adapters.dart';

class LocalCartService {
  final String _cartBoxName = 'cartBox';

  // Open or get Hive box
  Future<Box<ProductModel>> _getCartBox() async {
    return await Hive.openBox<ProductModel>(_cartBoxName);
  }

  // Retrieve all items from the local cart
  Future<List<ProductModel>> getCartItems() async {
    final box = await _getCartBox();
    return box.values.toList();
  }

  // Add an item to the local cart
  Future<void> addItemToCart(ProductModel item) async {
    final box = await _getCartBox();
    await box.put(item.id, item);
  }

  // Remove an item from the local cart
  Future<void> removeItemFromCart(String itemId) async {
    final box = await _getCartBox();
    await box.delete(itemId);
  }

  // Clear all items from the local cart (optional, for syncing purposes)
  Future<void> clearCart() async {
    final box = await _getCartBox();
    await box.clear();
  }
}
