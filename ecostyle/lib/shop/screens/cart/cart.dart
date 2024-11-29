import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/product_model.dart';
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
  bool _isConnected = true; // Tracks connectivity status
  final List<ProductModel> _localCart = []; // Temporary in-memory cart storage

  @override
  void initState() {
    super.initState();
    _listenToConnectivityChanges();
    _cartItemsFuture = _fetchCartItems();
  }

  void _listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });

      // Fetch items again if connectivity status changes
      if (_isConnected) {
        setState(() {
          _cartItemsFuture = _fetchCartItems();
        });
      }
    });
  }

  Future<List<ProductModel>> _fetchCartItems() async {
    try {
      if (!_isConnected) {
        // Return local in-memory items when offline
        return _localCart;
      } else {
        // Fetch online items from Firebase
        final firebaseService = Provider.of<FirebaseService>(context, listen: false);
        final onlineItems = await firebaseService.fetchCartItems();

        // Sync online items to local in-memory storage
        _localCart
          ..clear()
          ..addAll(onlineItems);

        return onlineItems;
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _fetchCartItems: $e\n$stackTrace');
      throw Exception('Failed to fetch cart items. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _cartItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                    await _confirmRemoveFromCartByTitle(context, item.title);
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
    return items.fold(0, (total, item) => total + (item.price ?? 0.0));
  }

  Future<void> _confirmRemoveFromCartByTitle(BuildContext context, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Are you sure you want to remove "$title" from the cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _removeFromCartByTitle(context, title);
    }
  }

  Future<void> _removeFromCartByTitle(BuildContext context, String title) async {
    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);

      if (_isConnected) {
        // Remove item from Firebase if online
        await firebaseService.removeItemFromCartByTitle(title);
      }

      // Remove item from local in-memory storage
      _localCart.removeWhere((item) => item.title == title);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );

      // Refresh cart items
      setState(() {
        _cartItemsFuture = _fetchCartItems();
      });
    } catch (e, stackTrace) {
      debugPrint('Error in _removeFromCartByTitle: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove item. Please try again later.')),
      );
    }
  }

}
