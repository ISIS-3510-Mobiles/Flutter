import 'package:flutter/material.dart';
import 'package:ecostyle/models/product_model.dart';

class CartItemWidget extends StatelessWidget {
  final ProductModel item;
  final VoidCallback onRemove;

  const CartItemWidget({
    required this.item,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: item.image.isNotEmpty
            ? Image.network(
          item.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
        )
            : Icon(Icons.image_not_supported),
        title: Text(item.title),
        subtitle: Text('\$${item.price}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
