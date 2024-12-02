import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecostyle/AppScaffold.dart';
import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:ecostyle/views/list_items_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPaymentMethod;
  String? _shippingAddress; // Variable to store the shipping address

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
  }

  // Fetch the user's shipping address from Firestore
  Future<void> _fetchUserAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Assuming you have a "users" collection where user data is stored
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _shippingAddress = userDoc.data()?['shippingAddress'] ?? 'Address not available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return FutureBuilder<List<ProductModel>>(
      future: firebaseService.fetchCartItems(),
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
                  _buildPaymentMethodSection(),
                  const SizedBox(height: 20),
                  _buildShippingAddressSection(),
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
                await _handlePlaceOrder(firebaseService, cartItems);
              },
              child: Text('Place Order (\$${(_calculateTotal(cartItems) + 2000).toStringAsFixed(2)})'),
            ),
          )
              : null,
        );
      },
    );
  }

  // Build cart item row
  Widget _buildCartItemRow(BuildContext context, ProductModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item.title, style: Theme.of(context).textTheme.bodyMedium),
        Text('\$${item.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  // Build total section
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

  // Payment method section
  Widget _buildPaymentMethodSection() {
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

  // Shipping address section
  Widget _buildShippingAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Address', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10.0),
        Text(
          _shippingAddress ?? 'Loading address...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  // Calculate total price
  double _calculateTotal(List<ProductModel> items) {
    return items.fold(0.0, (total, item) => total + item.price);
  }

  // Handle placing order
  Future<void> _handlePlaceOrder(FirebaseService firebaseService, List<ProductModel> cartItems) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Show offline modal
      _showOfflineDialog();
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    await firebaseService.clearCart(); // Clear the cart after placing the order
    _showSuccessDialog();
  }

  // Show offline dialog
  void _showOfflineDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show success dialog
  void _showSuccessDialog() {
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AppScaffold(child: ListItemsView(), routeName: '/list'),
                  ),
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
