import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/shop/screens/cart/widgets/cart_items.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout', style: Theme
          .of(context)
          .textTheme
          .headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const TCartItems(showButtons: false,),
                const SizedBox(height: 12.0,),

                ///Coupons
                Container(

                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Promo code'
                          ),),
                      ),
                      ElevatedButton(onPressed: (){}, child: const Text('Apply')),

                  ],

                ),),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SubTotal', style: Theme.of(context).textTheme.bodyMedium,),
                          Text('\$256', style: Theme.of(context).textTheme.bodyMedium,),
                        ],
                      ),
                      const SizedBox(height: 12.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipping and handling', style: Theme.of(context).textTheme.bodyMedium,),
                          Text('\$2', style: Theme.of(context).textTheme.labelLarge,),
                        ],
                      ),
                      const SizedBox(height: 12.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: Theme.of(context).textTheme.bodyMedium,),
                          Text('\$258', style: Theme.of(context).textTheme.titleLarge,),
                        ],
                      ),
                    ],
                  ),),
                  Column(
                    children: [
                      Text('Payment Method', style: Theme.of(context).textTheme.titleLarge,),
                      Text('Billing Address', style: Theme.of(context).textTheme.titleLarge,),
                      Text('Shipping Address', style: Theme.of(context).textTheme.titleLarge,),

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
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const CheckoutScreen()),
        );
        }, child: const Text('Checkout \$256.0')),
    ),);
  }
}