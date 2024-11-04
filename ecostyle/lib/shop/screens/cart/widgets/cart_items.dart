import 'package:ecostyle/models/product_model.dart';
import 'package:flutter/material.dart';

// Widget for individual cart items
class CartItemWidget extends StatelessWidget {
  final ProductModel item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Display product image
          Image.asset(item.image, width: 60, height: 60), // Ensure imageUrl exists in ProductModel
          const SizedBox(width: 12.0),

          // Display product title and attributes
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.bodyLarge),
                Text('\$${item.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          // Quantity control buttons can be added here if needed
        ],
      ),
    );
  }
}