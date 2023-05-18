import 'package:bookcenter/components/skleton/others/discover_categories_skelton.dart';
import 'package:bookcenter/screens/home/views/components/categories.dart';
import 'package:bookcenter/screens/shop/controllers/shop_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';

import 'components/expansion_category.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetX<ShopController>(
          init: ShopController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Padding(
                //   padding: EdgeInsets.all(defaultPadding),
                //   child: SearchForm(),
                // ),
                const Categories(visibleIndex: [2, 3, 4]),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                    vertical: defaultPadding / 2,
                  ),
                  child: Text(
                    "Categories",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                // While loading use 👇
                Expanded(
                  child: controller.isFetchingCategories.value
                      ? const DiscoverCategoriesSkelton()
                      : ListView.builder(
                          itemCount: controller.categories.length,
                          itemBuilder: (context, index) => ExpansionCategory(
                            svgSrc: controller.categories[index].categoryIcon!,
                            title: controller.categories[index].categoryTitle!,
                            subCategory:
                                controller.categories[index].subCategories,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
