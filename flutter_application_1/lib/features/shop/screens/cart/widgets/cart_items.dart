import 'package:flutter/material.dart';

import '../cart.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key, this.showButtons = true,
  });

  final  bool showButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(height: 32.0,),
      itemCount: 2,
      itemBuilder: (_, index)=> Column(
        children: [
          const CartItem(),
          if (showButtons) const SizedBox(width: 12.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            /// +/- buttons
            children: [
              if(showButtons) const Row(
                children: [
                  SizedBox( width: 70,),
                  TAddRemoveQuantityButton(),
                ],
              ),
              const SizedBox( width: 70,),
              const Text('\$115')

            ],
          )
        ],
      ),
    );
  }
}