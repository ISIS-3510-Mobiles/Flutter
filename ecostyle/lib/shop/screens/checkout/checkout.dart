import 'package:ecostyle/AppScaffold.dart';
import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:ecostyle/views/list_items_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPaymentMethod; // New state variable for payment method

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
                if (_selectedPaymentMethod == null) {
                  // Optionally, you can show a message if no payment method is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a payment method')),
                  );
                  return;
                }

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
        ListTile(
          title: const Text('Credit Card'),
          leading: Radio<String>(
            value: 'credit_card',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Cash on Delivery'),
          leading: Radio<String>(
            value: 'cash_on_delivery',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value;
              });
            },
          ),
        ),
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
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AppScaffold(child: ListItemsView(), routeName: '/list')), // Navigate to your ProductListView
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
