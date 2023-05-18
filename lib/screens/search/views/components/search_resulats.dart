import 'package:bookcenter/components/skleton/skelton.dart';
import 'package:bookcenter/screens/search/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/product/product_card.dart';
import 'package:bookcenter/models/product_model.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class SearchResulats extends StatelessWidget {
  const SearchResulats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SearchController>(
      init: SearchController(),
      builder: (controller) {
        return Expanded(
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount:
                controller.isSearching.value && controller.isSearching.value
                    ? controller.searchResults.length + 4
                    : controller.searchResults.length,
            itemBuilder: (BuildContext context, int index) {
              if (controller.searchResults.length <= index &&
                  controller.isSearching.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Skeleton(
                    height: 70,
                  ),
                );
              }
              return Column(
                children: [
                  ListTile(
                    title: Text(controller.searchResults[index].value),
                    subtitle: Text(controller.searchResults[index].type),
                    onTap: () {
                      controller.navigateToPage(
                        id: controller.searchResults[index].id,
                        type: controller.searchResults[index].type,
                        value: controller.searchResults[index].value,
                        parentId: controller.searchResults[index].parentId,
                        context: context,
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
