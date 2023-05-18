import 'package:flutter/material.dart';

import '../../../../constants.dart';
import 'upcoming_event.dart';

class AlbumsCarousel extends StatelessWidget {
  const AlbumsCarousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Latest Albums",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const OffersSkelton(),
        const UpcomingEventCarousel(),
      ],
    );
  }
}
