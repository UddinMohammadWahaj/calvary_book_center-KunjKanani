import 'package:flutter/material.dart';
import 'package:bookcenter/route/screen_export.dart';

import '../../../../constants.dart';
import 'search_suggestion_text.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> demoRecentSearch = [
      "White Shirt",
      "Blue short",
      "Red shirt",
      "Gray Dress",
      "Yellow Top &  short"
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Searches",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, searchHistoryScreenRoute);
                },
                child: const Text("See All"),
              ),
            ],
          ),
        ),
        ...List.generate(
          demoRecentSearch.length,
          (index) => SearchSuggestionText(
            text: demoRecentSearch[index],
            isRecentSearch: true,
            press: () {},
            onTapClose: () {},
          ),
        ),
      ],
    );
  }
}
