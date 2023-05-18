import 'package:bookcenter/screens/shop/models/category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class ExpansionCategory extends StatelessWidget {
  const ExpansionCategory({
    Key? key,
    required this.title,
    required this.subCategory,
    required this.svgSrc,
  }) : super(key: key);

  final String title, svgSrc;
  final List<SubCategory> subCategory;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Theme.of(context).textTheme.bodyLarge!.color,
      collapsedIconColor: Theme.of(context).textTheme.bodyMedium!.color,
      leading: svgSrc.contains('.svg')
          ? SvgPicture.asset(
              svgSrc,
              height: 24,
              width: 24,
            )
          : CachedNetworkImage(
              imageUrl: svgSrc,
              height: 24,
              width: 24,
            ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      textColor: Theme.of(context).textTheme.bodyLarge!.color,
      childrenPadding: const EdgeInsets.only(left: defaultPadding * 3.5),
      children: List.generate(
        subCategory.length,
        (index) => Column(
          children: [
            ListTile(
              onTap: () {
                // Navigator.pushNamed(
                //   context,
                //   productListScreenRoute,
                //   arguments: {
                //     "title": subCategory[index].,
                //   },
                // );

                Get.toNamed(
                  productListScreenRoute,
                  arguments: {
                    "title": title,
                    "id": subCategory[index].id,
                    "subCategories": subCategory,
                    "selectedIndex": index,
                  },
                );
              },
              title: Text(
                subCategory[index].name ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 12),
            ),
            if (index < subCategory.length - 1) const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
