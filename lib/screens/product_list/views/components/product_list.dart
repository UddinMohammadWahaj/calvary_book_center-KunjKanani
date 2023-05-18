import 'dart:developer';

import 'package:bookcenter/components/product/grid_product_card.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/product/product_card.dart';
import 'package:bookcenter/models/product_model.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: defaultPadding / 2),
          // Padding(
          //   padding: const EdgeInsets.all(defaultPadding),
          //   child: Text(
          //     "All Products",
          //     style: Theme.of(context).textTheme.subtitle2,
          //   ),
          // ),
          // While loading use 👇
          // const ProductsSkelton(),
          Flexible(
            fit: FlexFit.loose,
            child: GridView.builder(
              // scrollDirection: Axis.vertical,
              // Find demoBestSellersProducts on models/ProductModel.dart
              padding: const EdgeInsets.only(
                right: defaultPadding,
                left: defaultPadding,
                bottom: defaultPadding * 10,
              ),
              itemCount: demoBestSellersProducts.length,
              itemBuilder: (context, index) => GridProductCard(
                image: demoBestSellersProducts[index].image,
                brandName: demoBestSellersProducts[index].brandName,
                title: demoBestSellersProducts[index].title,
                price: demoBestSellersProducts[index].price,
                priceAfetDiscount:
                    demoBestSellersProducts[index].priceAfetDiscount,
                dicountpercent: demoBestSellersProducts[index].dicountpercent,
                press: () {
                  Get.toNamed(
                    productDetailsScreenRoute,
                    arguments: index.isEven,
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
