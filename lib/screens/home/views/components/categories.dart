import 'package:bookcenter/components/piil_button.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/service/entry_point_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

// For preview
class CategoryModel {
  final String name;
  final String? svgSrc;
  final String? route;
  final VoidCallback? onPressed;

  CategoryModel({
    required this.name,
    this.svgSrc,
    this.route,
    this.onPressed,
  });
}

List<CategoryModel> demoCategories = [
  // CategoryModel(
  //   name: "All Categories",
  // ),
  CategoryModel(
    name: "Daily Promises",
    svgSrc: "assets/newIcon/promise.png",
    route: dailyPromisesScreenRoute,
    onPressed: () {},
  ),
  CategoryModel(
    name: "Shop",
    svgSrc: "assets/icons/Sale.svg",
    onPressed: () {
      Get.find<EntryPointService>().currentPage.value = 1;
    },
    // route: onSaleScreenRoute,
  ),
  CategoryModel(
    name: "Books",
    svgSrc: "assets/newIcon/book.png",
    route: bookStoreCategoryScreenRoute,
  ),
  CategoryModel(
    name: "Albums",
    svgSrc: "assets/newIcon/music.png",
    route: albumsListScreenRoute,
  ),
  CategoryModel(
    name: "Sermons",
    svgSrc: "assets/newIcon/video.png",
    route: sermonsListScreenRoute,
  ),
];
// End For Preview

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
    this.visibleIndex = const [0, 1, 2, 3, 4],
  }) : super(key: key);

  final List<int> visibleIndex;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            demoCategories.length,
            (index) => Visibility(
              visible: visibleIndex.contains(index),
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? defaultPadding : defaultPadding / 2,
                  right:
                      index == demoCategories.length - 1 ? defaultPadding : 0,
                ),
                child: PillButton(
                  text: demoCategories[index].name,
                  svgSrc: demoCategories[index].svgSrc,
                  isActive: false,
                  press: () {
                    demoCategories[index].onPressed?.call();
                    if (demoCategories[index].route != null) {
                      Get.toNamed(demoCategories[index].route!);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
