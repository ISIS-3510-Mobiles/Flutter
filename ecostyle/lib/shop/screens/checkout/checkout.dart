import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return FutureBuilder<List<ProductModel>>(
      future: firebaseService.fetchCartItems(), // Fetch cart items
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
            title: Text('Checkout', style: Theme.of(context).textTheme.headlineSmall),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: cartItems.isNotEmpty
                  ? Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItemRow(context, item);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTotalSection(cartItems),
                  const SizedBox(height: 20),
                  _buildPaymentMethodSection(context),
                  const SizedBox(height: 20),
                  _buildShippingAddressSection(context),
                ],
              )
                  : const Center(child: Text('Your cart is empty.')),
            ),
          ),
          bottomNavigationBar: cartItems.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await firebaseService.clearCart(); // Clear the cart after placing the order
                _showSuccessDialog(context);
              },
              child: Text('Place Order (\$${(_calculateTotal(cartItems) + 2000).toStringAsFixed(2)})'),
            ),
          )
              : null,
        );
      },
    );
  }

  Widget _buildCartItemRow(BuildContext context, ProductModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item.title, style: Theme.of(context).textTheme.bodyMedium),
        Text('\$${item.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildTotalSection(List<ProductModel> items) {
    double total = _calculateTotal(items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subtotal: \$${total.toStringAsFixed(2)}'),
        const SizedBox(height: 10),
        Text('Platform cost: \$2000.00'),

        const SizedBox(height: 10),
        Text('Total: \$${(total + 2000).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10.0),
        Row(children: [Icon(Icons.credit_card, size: 30.0), const SizedBox(width: 8.0), Text('Credit Card', style: Theme.of(context).textTheme.bodyLarge)]),
        const SizedBox(height: 10.0),
        Row(children: [Icon(Icons.money, size: 30.0), const SizedBox(width: 8.0), Text('Cash on Delivery', style: Theme.of(context).textTheme.bodyLarge)]),
      ],
    );
  }

  Widget _buildShippingAddressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Address', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10.0),
        Text('Lorem ipsum dolor sit amet,\n1234 Main St, Apt 5B,\nSpringfield, USA', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  // Helper method to calculate total price
  double _calculateTotal(List<ProductModel> items) {
    return items.fold(0.0, (total, item) => total + item.price);
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Your order has been placed successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
