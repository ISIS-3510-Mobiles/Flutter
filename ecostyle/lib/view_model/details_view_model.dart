import 'package:flutter/material.dart';
import 'package:ecostyle/models/product_model.dart';

class DetailViewModel extends ChangeNotifier {
  late ProductModel currentItem;
  late List<ProductModel> recommendedItems;

  List<ProductModel> cartItems = []; // List to hold cart items

  // Initialize product data and recommendations
  void init(ProductModel item, List<ProductModel> allItems) {
    currentItem = item;
    recommendedItems = _getRecommendedItems(item, allItems);
    notifyListeners(); // Notify the view that data has changed
  }

  // Method to get recommended products
  List<ProductModel> _getRecommendedItems(ProductModel currentItem, List<ProductModel> allItems) {
    String title = currentItem.title.toLowerCase();
    List<ProductModel> similarItems = [];

    // Find products with similar words in title
    List<String> words = title.split(' ');

    for (String word in words) {
      for (var item in allItems) {
        if (item.title != currentItem.title && item.title.toLowerCase().contains(word)) {
          if (!similarItems.any((selectedItem) => selectedItem.title == item.title)) {
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

  // Add the current item to the cart
  void addToCart(ProductModel item) {
    cartItems.add(item);
    notifyListeners(); // Notify listeners to update UI
    print('Added to cart: ${item.title}');
  }

  // Remove an item from the cart
  void removeFromCart(ProductModel item) {
    cartItems.removeWhere((cartItem) => cartItem.title == item.title);
    notifyListeners(); // Notify the view that the cart has changed
  }

  // Check if the current item is in the cart
  bool isInCart(ProductModel item) {
    return cartItems.any((cartItem) => cartItem.title == item.title);
  }

  // Get total cart value
  double get cartTotal {
    return cartItems.fold(0.0, (total, item) => total + item.price);
  }

  // Clear the cart
  void clearCart() {
    cartItems.clear();
    notifyListeners(); // Notify the view that the cart has changed
  }

  // Get the quantity of a specific item in the cart
  int getItemQuantity(ProductModel item) {
    return cartItems.where((cartItem) => cartItem.title == item.title).length;
  }
}
