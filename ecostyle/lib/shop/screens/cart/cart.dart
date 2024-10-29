import 'package:ecostyle/shop/screens/cart/widgets/cart_items.dart';
import 'package:ecostyle/shop/screens/checkout/checkout.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cart', style: Theme
            .of(context)
            .textTheme
            .headlineSmall)),
        body: const Padding(
          padding: EdgeInsets.all(24.0),
          child: TCartItems(),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const CheckoutScreen()),
              );
            }, child: const Text('Checkout \$256.0')),
        ),
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