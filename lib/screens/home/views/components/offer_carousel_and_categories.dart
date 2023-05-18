import 'package:bookcenter/constants.dart';
import 'package:flutter/material.dart';
import 'categories.dart';
import 'upcoming_event.dart';

class OffersCarouselAndCategories extends StatelessWidget {
  const OffersCarouselAndCategories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Categories(),
        SizedBox(height: defaultPadding / 2),
        UpcomingEventCarousel(),
        // SizedBox(height: defaultPadding / 2),
        // Padding(
        //   padding: EdgeInsets.all(defaultPadding),
        //   child: Text(
        //     "Categories",
        //     style: Theme.of(context).textTheme.subtitle2,
        //   ),
        // ),
        // While loading use 👇
        // CategoriesSkelton(),
        // SizedBox(height: defaultPadding / 2),
        // Padding(
        //   padding: const EdgeInsets.all(defaultPadding),
        //   child: Text(
        //     "Daily Promises",
        //     style: Theme.of(context).textTheme.subtitle2,
        //   ),
        // ),
        // const OffersCarousel(),
      ],
    );
  }
}
