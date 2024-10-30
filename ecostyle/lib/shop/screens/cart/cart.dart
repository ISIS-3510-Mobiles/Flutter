import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:ecostyle/shop/screens/cart/widgets/cart_items.dart';
import 'package:ecostyle/shop/screens/checkout/checkout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return FutureBuilder<List<ProductModel>>(
      future: firebaseService.fetchCartItems(), // Fetch cart items
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
                return CartItemWidget(item: item);
              },
            )
                : const Center(child: Text('Your cart is empty.')),
          ),
          bottomNavigationBar: cartItems.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Proceed to checkout
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

  // Helper method to calculate total price
  double _calculateTotal(List<ProductModel> items) {
    return items.fold(0, (total, item) => total + item.price);
  }
}
