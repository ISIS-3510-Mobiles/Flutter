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
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final cartItems = snapshot.data ?? [];

          return cartItems.isNotEmpty
              ? CartItemsList(
            cartItems: cartItems,
            onRemove: (title) => _removeFromCartByTitle(context, title),
          )
              : const Center(child: Text('Your cart is empty.'));
        },
      ),
      bottomNavigationBar: FutureBuilder<List<ProductModel>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done || snapshot.data?.isEmpty == true) {
            return const SizedBox.shrink();
          }
          return CheckoutButton(cartItems: snapshot.data!);
        },
      ),
    );
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

      // Show a SnackBar using ScaffoldMessenger
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

class CartItemsList extends StatelessWidget {
  final List<ProductModel> cartItems;
  final Future<void> Function(String title) onRemove;

  const CartItemsList({
    super.key,
    required this.cartItems,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return CartItemWidget(
          item: item,
          onRemove: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Remove Item'),
                content: Text('Are you sure you want to remove "${item.title}" from the cart?'),
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
              await onRemove(item.title);
            }
          },
        );
      },
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final List<ProductModel> cartItems;

  const CheckoutButton({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    final total = cartItems.fold(0.0, (sum, item) => sum + (item.price ?? 0.0));

    return Padding(
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
        child: Text('Checkout (\$${total.toStringAsFixed(2)})'),
      ),
    );
  }
}
