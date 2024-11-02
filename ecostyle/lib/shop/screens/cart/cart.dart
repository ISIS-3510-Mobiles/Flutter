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

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _fetchCartItems();
  }

  Future<List<ProductModel>> _fetchCartItems() {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    return firebaseService.fetchCartItems();
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
    await firebaseService.removeItemFromCart(itemId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item removed from cart')));

    // Refresh the cart items after removal
    setState(() {
      _cartItemsFuture = _fetchCartItems();
    });
  }
}
