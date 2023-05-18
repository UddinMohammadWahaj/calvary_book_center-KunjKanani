import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../skelton.dart';

class BannerMSkelton extends StatelessWidget {
  const BannerMSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.56,
      child: Stack(
        children: [
          const Skeleton(radious: 0),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Skeleton(
                  height: 24,
                  width: 200,
                ),
                SizedBox(height: defaultPadding / 2),
                Skeleton(
                  height: 24,
                  width: 160,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
