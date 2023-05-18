import 'dart:developer';

import 'package:bookcenter/components/skleton/skelton.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/home/controllers/home_controller.dart';
import 'package:bookcenter/screens/home/views/components/popular_book_tile.dart';
import 'package:bookcenter/service/service_elements/book_payment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Popularbooks extends StatelessWidget {
  const Popularbooks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Popular books",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 240,
          child: GetX<HomeController>(
            builder: (controller) {
              return controller.isFetchingLastestBooks.value
                  ? ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: defaultPadding,
                            right: index == controller.lastestBooks.length - 1
                                ? defaultPadding
                                : 0,
                          ),
                          child: const Skeleton(
                            width: 150,
                            height: 220,
                            radious: 10,
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // Find controller.lastestBooks on models/ProductModel.dart
                      itemCount: controller.lastestBooks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: defaultPadding / 2,
                            right: index == controller.lastestBooks.length - 1
                                ? defaultPadding / 2
                                : 0,
                          ),
                          child: PopularBookTile(
                            id: controller.lastestBooks[index].id,
                            isPurchased:
                                controller.lastestBooks[index].paymentStatus ==
                                    'P',
                            image: controller.lastestBooks[index].bookLogo!,
                            // brandName: controller.lastestBooks[index].bookTeluguTitle,
                            title: controller.lastestBooks[index].bookTitle,

                            // priceAfetDiscount:
                            //     controller.lastestBooks[index].priceAfetDiscount,
                            // dicountpercent:
                            //     controller.lastestBooks[index].dicountpercent,
                            press: () {
                              showModalBottomSheet(
                                context: context,
                                constraints: BoxConstraints(
                                  maxHeight: Get.width * 1.8,
                                  minHeight: Get.width * 1.8,
                                ),
                                isDismissible: false,
                                enableDrag: false,
                                builder: (context) {
                                  return BookPaymentBottomSheet(
                                    book: controller.lastestBooks[index],
                                    onPressedDownload: () {
                                      var controller =
                                          Get.find<HomeController>();
                                      controller.downloadBook(
                                        bookId:
                                            controller.lastestBooks[index].id,
                                        bookUrl: controller
                                            .lastestBooks[index].book!,
                                        bookName: controller
                                            .lastestBooks[index].bookTitle,
                                      );
                                      Get.back();
                                    },
                                  );
                                },
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                              );
                            },
                            brandName: '',
                            price: 0,
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}
