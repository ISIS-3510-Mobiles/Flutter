import 'package:ecostyle/shop/screens/cart/widgets/cart_items.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const TCartItems(showButtons: false),
              const SizedBox(height: 12.0),

              /// Coupons
              Container(
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Promo code',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),

              /// SubTotal, Shipping, and Total
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SubTotal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$256',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping and handling',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$2',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$258',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),

              /// Payment Method
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Icon(Icons.credit_card, size: 30.0),
                      const SizedBox(width: 8.0),
                      Text(
                        'Credit Card',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Icon(Icons.money, size: 30.0),
                      const SizedBox(width: 8.0),
                      Text(
                        'Cash on Delivery',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              /// Shipping Address
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipping Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Lorem ipsum dolor sit amet,\n'
                        '1234 Main St, Apt 5B,\n'
                        'Springfield, USA',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // Show the success dialog
            _showSuccessDialog(context);
          },
          child: const Text('Checkout \$256.0'),
        ),
      ),
    );
  }

  // Success dialog placeholder
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
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
