import 'package:flutter/material.dart';

import '../../constants.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
    this.layer = 1,
    this.radious = defaultPadding,
    this.child = const SizedBox(),
  }) : super(key: key);

  final double? height, width;
  final int layer;
  final double radious;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).iconTheme.color!.withOpacity(0.04 * layer),
        borderRadius: BorderRadius.all(
          Radius.circular(radious),
        ),
      ),
      child: child,
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      // padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor.withOpacity(0.04),
        color: Theme.of(context).iconTheme.color!.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
