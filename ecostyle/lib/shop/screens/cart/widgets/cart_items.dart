import 'package:ecostyle/models/product_model.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final ProductModel item;
  final VoidCallback onRemove; // Callback for the remove action

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Display product image
          Image.asset(item.image, width: 60, height: 60),
          const SizedBox(width: 12.0),

          // Display product title and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.bodyLarge),
                Text('\$${item.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),

          // Remove button
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onRemove, // Calls the onRemove callback
          ),
        ],
      ),
    );
  }
}
