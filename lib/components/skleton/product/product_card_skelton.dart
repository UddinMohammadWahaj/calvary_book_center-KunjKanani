import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../skelton.dart';

class ProductCardSkelton extends StatelessWidget {
  const ProductCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 140,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AspectRatio(
              aspectRatio: 1.15,
              child: Skeleton(),
            ),
            // Spacer(),
            // Skeleton(height: 12, width: 64),
            Spacer(),
            Skeleton(),
            // Spacer(),
            // Skeleton(),
            Spacer(),
            Skeleton(height: 12, width: 80),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
