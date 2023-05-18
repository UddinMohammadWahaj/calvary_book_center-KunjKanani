import 'package:flutter/material.dart';

import '../../../../constants.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    Key? key,
    required this.subTotal,
    this.shippingFee,
    required this.totalWithTaxes,
    this.discount,
    this.tip,
    this.couponDiscount,
  }) : super(key: key);
  final double subTotal, totalWithTaxes;

  final double? discount, couponDiscount, shippingFee, tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: defaultPadding / 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: OrderSummaryText(
              leadingText: "Subtotal",
              trilingText: "₹$subTotal",
            ),
          ),
          if (tip != null)
            OrderSummaryText(
              leadingText: "Donation",
              trilingText: "₹$tip",
            ),
          if (tip != null) const SizedBox(height: defaultPadding / 2),
          if (shippingFee != null)
            OrderSummaryText(
              leadingText: "Shipping Fee",
              trilingText:
                  shippingFee == 0 ? "Calculate in next step" : "₹$shippingFee",
              trilingTextColor: shippingFee == 0 ? successColor : null,
            ),
          if (discount != null) const SizedBox(height: defaultPadding / 2),
          if (discount != null)
            OrderSummaryText(
              leadingText: "Discount",
              trilingText: "₹$discount",
            ),
          if (couponDiscount != null)
            const SizedBox(height: defaultPadding / 2),
          if (couponDiscount != null)
            OrderSummaryText(
              leadingText: "Coupon Discount",
              trilingText: "₹$couponDiscount",
            ),
          const Divider(height: defaultPadding * 2),
          OrderSummaryText(
            leadingText: "Total (Include of Taxes)",
            trilingText: "₹$totalWithTaxes",
          ),
        ],
      ),
    );
  }
}

class OrderSummaryText extends StatelessWidget {
  const OrderSummaryText({
    Key? key,
    required this.leadingText,
    required this.trilingText,
    this.trilingTextColor,
  }) : super(key: key);

  final String leadingText, trilingText;
  final Color? trilingTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(leadingText),
        const Spacer(),
        Text(
          trilingText,
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: trilingTextColor),
        ),
      ],
    );
  }
}
