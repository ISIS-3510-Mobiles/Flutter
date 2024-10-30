import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecostyle/models/product_model.dart';

class DetailViewModel extends ChangeNotifier {
  late ProductModel currentItem;
  late List<ProductModel> recommendedItems;

  // Initialize product data and recommendations
  void init(ProductModel item, List<ProductModel> allItems) {
    currentItem = item;
    recommendedItems = _getRecommendedItems(item, allItems);
    notifyListeners(); // Notify the view that data has changed
  }

  // Method to get recommended products
  List<ProductModel> _getRecommendedItems(ProductModel currentItem,
      List<ProductModel> allItems) {
    String title = currentItem.title.toLowerCase();
    List<ProductModel> similarItems = [];

    // Find products with similar words in title
    List<String> words = title.split(' ');

    for (String word in words) {
      for (var item in allItems) {
        if (item.title != currentItem.title &&
            item.title.toLowerCase().contains(word)) {
          if (!similarItems.any((selectedItem) =>
          selectedItem.title == item.title)) {
            similarItems.add(item);
          }
        }
      }
    }

    if (similarItems.isNotEmpty) {
      // Sort by price
      similarItems.sort((a, b) => a.price.compareTo(b.price));
      return similarItems.take(3).toList(); // Return the 3 cheapest
    } else {
      // If no similar products, return the 3 cheapest overall
      List<ProductModel> sortedItems = List.from(allItems);
      sortedItems.sort((a, b) => a.price.compareTo(b.price));
      return sortedItems.take(3).toList(); // Return the 3 cheapest
    }
  }

  Future<void> addToCart(ProductModel item) async {
    String userId = "temp"; // Retrieve this from your authentication method
    DocumentReference cartRef = FirebaseFirestore.instance.collection('carts_users')
        .doc(userId);

    // Add item to the cart
    await cartRef.set({
      'items': FieldValue.arrayUnion([item.toMap()])
    }, SetOptions(merge: true));

    notifyListeners();
  }
}
