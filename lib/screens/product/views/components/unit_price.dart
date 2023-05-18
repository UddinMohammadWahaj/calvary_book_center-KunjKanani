import 'package:flutter/material.dart';

import '../../../../constants.dart';

class UnitPrice extends StatelessWidget {
  const UnitPrice({
    Key? key,
    required this.price,
    this.priceAfterDiscount,
  }) : super(key: key);

  final double price;
  final double? priceAfterDiscount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Unit price",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: defaultPadding / 1),
        Text.rich(
          TextSpan(
            text: priceAfterDiscount == null
                ? "Rs.${price.toStringAsFixed(2)}  "
                : "Rs.${priceAfterDiscount!.toStringAsFixed(2)}  ",
            style: Theme.of(context).textTheme.headline6,
            children: [
              if (priceAfterDiscount != null)
                TextSpan(
                  text: "Rs.${price.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      decoration: TextDecoration.lineThrough),
                ),
            ],
          ),
        )
      ],
    );
  }
}
