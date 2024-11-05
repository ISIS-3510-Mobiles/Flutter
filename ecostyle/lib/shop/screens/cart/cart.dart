import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:ecostyle/shop/controlers/LocalCartService.dart';
import 'package:ecostyle/shop/screens/cart/widgets/cart_items.dart';
import 'package:ecostyle/shop/screens/checkout/checkout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<ProductModel>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _fetchCartItems();
  }

  Future<List<ProductModel>> _fetchCartItems() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final localCartService = LocalCartService();

    if (connectivityResult == ConnectivityResult.none) {
      // Return local items when offline
      return await localCartService.getCartItems();
    } else {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final onlineItems = await firebaseService.fetchCartItems();

      // Sync local storage with online data
      await localCartService.clearCart();
      for (var item in onlineItems) {
        await localCartService.addItemToCart(item);
      }
      return onlineItems;
    }
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ProductModel>>(
      future: _cartItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final cartItems = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: cartItems.isNotEmpty
                ? ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemWidget(
                  item: item,
                  onRemove: () async {
                    await _removeFromCart(context, item.id);
                  },
                );
              },
            )
                : const Center(child: Text('Your cart is empty.')),
          ),
          bottomNavigationBar: cartItems.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
              child: Text('Checkout (\$${_calculateTotal(cartItems)})'),
            ),
          )
              : null,
        );
      },
    );
  }

  double _calculateTotal(List<ProductModel> items) {
    return items.fold(0, (total, item) => total + item.price);
  }

  Future<void> _removeFromCart(BuildContext context, String itemId) async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final localCartService = LocalCartService();

    // Remove item from Firebase if online
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await firebaseService.removeItemFromCart(itemId);
    }

    // Remove item from local storage
    await localCartService.removeItemFromCart(itemId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item removed from cart')),
    );

    // Refresh cart items
    setState(() {
      _cartItemsFuture = _fetchCartItems();
    });
  }

}
