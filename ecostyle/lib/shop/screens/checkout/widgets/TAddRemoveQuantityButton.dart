import 'package:flutter/material.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:ecostyle/view_model/details_view_model.dart';

class TAddRemoveQuantityButton extends StatelessWidget {
  final ProductModel item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const TAddRemoveQuantityButton({
    Key? key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailViewModel = Provider.of<DetailViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (detailViewModel.getItemQuantity(item) > 1) {
              onRemove();
            }
          },
        ),
        Text(
          '${detailViewModel.getItemQuantity(item)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onAdd,
        ),
      ],
    );
  }
}
