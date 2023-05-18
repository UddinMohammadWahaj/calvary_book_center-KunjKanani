import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../skelton.dart';

class DiscoverCategoriesSkelton extends StatelessWidget {
  const DiscoverCategoriesSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => const DiscoverCategorySkelton(),
    );
  }
}

class DiscoverCategorySkelton extends StatelessWidget {
  const DiscoverCategorySkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding * 0.75),
      child: Row(
        children: const [
          Skeleton(
            height: 32,
            width: 32,
            radious: 8,
          ),
          SizedBox(width: defaultPadding),
          Expanded(
            flex: 2,
            child: Skeleton(),
          ),
          Spacer(),
          Skeleton(
            height: 18,
            width: 18,
            radious: 8,
          ),
        ],
      ),
    );
  }
}
