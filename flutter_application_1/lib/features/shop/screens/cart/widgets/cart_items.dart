import 'package:flutter/material.dart';
import '../cart.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key,
    this.showButtons = true,
  });

  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(height: 32.0),
      itemCount: 2,
      itemBuilder: (_, index) => Column(
        children: [
          const TCartItems(),
          if (showButtons) const SizedBox(width: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showButtons)
                Row(
                  children: const [
                    SizedBox(width: 12.0), // Added space before +/- buttons
                    TAddRemoveQuantityButton(),
                  ],
                ),
              const SizedBox(width: 12.0),
              const Text(
                '\$115',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
