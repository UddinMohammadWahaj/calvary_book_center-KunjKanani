import 'dart:developer';

import 'package:bookcenter/screens/reviews/controllers/review_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';

import 'components/review_form.dart';
import 'components/review_product_card.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Review"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            ReviewProductInfoCard(
              image: Get.find<ProductReviewController>()
                  .product
                  .productImages![0]
                  .productImg,
              title: Get.find<ProductReviewController>().product.productTitle ??
                  '',
              brand: "Calvary",
            ),
            const SizedBox(height: defaultPadding),
            const Divider(),
            const SizedBox(height: defaultPadding / 2),
            const Text("Your overall rating of this product"),
            const SizedBox(height: defaultPadding / 2),
            RatingBar.builder(
              initialRating: 0,
              itemSize: 28,
              itemPadding: const EdgeInsets.only(right: defaultPadding / 4),
              unratedColor: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.08),
              glow: false,
              allowHalfRating: false,
              onRatingUpdate: (value) {
                Get.find<ProductReviewController>().rating = value;
              },
              itemBuilder: (context, index) =>
                  SvgPicture.asset("assets/icons/Star_filled.svg"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
              child: Divider(),
            ),
            const ReviewForm()
          ],
        ),
      ),
    );
  }
}
