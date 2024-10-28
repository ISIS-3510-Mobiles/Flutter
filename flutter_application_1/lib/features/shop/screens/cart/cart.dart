import 'package:flutter_application_1/features/shop/controllers/cart_controler.dart';
import 'package:flutter_application_1/features/shop/models/cart_model.dart';
import 'package:flutter_application_1/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:flutter_application_1/features/shop/screens/checkout/checkout.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall)),
      body: FutureBuilder<List<CartItemModel>>(
        future: _cartService.fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading cart items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items in the cart'));
          }

          final cartItems = snapshot.data!;
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return CartItemWidget(item: item);
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
            );
          },
          child: Text('Checkout \$256.0'),
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/Jackets.jpg', width: 60, height: 60),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Color: ',
                        style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: item.color,
                        style: Theme.of(context).textTheme.bodyLarge),
                    TextSpan(
                        text: ' Size: ',
                        style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: item.size,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              Text('Quantity: ${item.quantity}'),
              Text('Price: \$${item.price}'),
            ],
          ),
        ),
      ],
    );
  }
}

class TAddRemoveQuantityButton extends StatelessWidget {
  const TAddRemoveQuantityButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('-', style: Theme.of(context).textTheme.titleSmall,),
        Text('2', style: Theme.of(context).textTheme.titleSmall,),
        Text('+', style: Theme.of(context).textTheme.titleSmall,),
      ],
    );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Image
        Image.asset('assets/images/Jackets.jpg', width: 60, height: 60),
        const SizedBox(width: 12.0,),

        /// Tittle and attributes
        Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Brand'),
                const Flexible(child:  Text('Jacket')),
                /// Attributes
                Text.rich(
                    TextSpan(
                        children: [
                          TextSpan(text: 'Color ', style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(text: 'Blue ', style: Theme.of(context).textTheme.bodyLarge),
                          TextSpan(text: 'Size ', style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(text: 'M ', style: Theme.of(context).textTheme.bodyLarge),
                        ]
                    )
                ),
              ],
            ))
      ],
    );
  }
}