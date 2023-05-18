import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import 'product_availability_tag.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    Key? key,
    required this.title,
    required this.brand,
    this.description = '',
    required this.rating,
    required this.numOfReviews,
    required this.isAvailable,
  }) : super(key: key);

  final String title, brand, description;
  final double rating;
  final int numOfReviews;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              brand.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              title,
              maxLines: 2,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              children: [
                ProductAvailabilityTag(isAvailable: isAvailable),
                const Spacer(),
                SvgPicture.asset("assets/icons/Star_filled.svg"),
                const SizedBox(width: defaultPadding / 4),
                Text(
                  "$rating ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text("($numOfReviews Reviews)")
              ],
            ),
            if (description.isNotEmpty) const SizedBox(height: defaultPadding),
            if (description.isNotEmpty)
              Text(
                "Product info",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            if (description.isNotEmpty)
              const SizedBox(height: defaultPadding / 2),
            if (description.isNotEmpty)
              Text(
                description,
                style: const TextStyle(height: 1.4),
              ),
            const SizedBox(height: defaultPadding / 2),
          ],
        ),
      ),
    );
  }
}
