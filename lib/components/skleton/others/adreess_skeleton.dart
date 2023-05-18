import 'package:bookcenter/components/skleton/skelton.dart';
import 'package:bookcenter/constants.dart';
import 'package:flutter/material.dart';

class AddressSkeleton extends StatelessWidget {
  const AddressSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            Skeleton(
              layer: 1,
              radious: defaultBorderRadious,
              height: 60,
            ),
            SizedBox(height: defaultPadding * 2),
            Skeleton(
              layer: 1,
              radious: defaultBorderRadious,
              height: 160,
            ),
            SizedBox(height: defaultPadding),
            Skeleton(
              layer: 1,
              radious: defaultBorderRadious,
              height: 160,
            ),
            SizedBox(height: defaultPadding),
            Skeleton(
              layer: 1,
              radious: defaultBorderRadious,
              height: 160,
            ),
            SizedBox(height: defaultPadding),
            Skeleton(
              layer: 1,
              radious: defaultBorderRadious,
              height: 160,
            ),
          ],
        ),
      ),
    );
  }
}
