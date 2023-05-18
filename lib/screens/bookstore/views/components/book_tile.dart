import 'package:bookcenter/components/network_image_with_loader.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/bookstore/controllers/book_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookTile extends StatelessWidget {
  const BookTile({
    Key? key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.isPurchased = false,
    required this.index,
    required this.id,
    required this.press,
  }) : super(key: key);
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? id, index;
  final VoidCallback press;
  final bool isPurchased;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(150, 220),
        maximumSize: const Size(150, 220),
        padding: const EdgeInsets.all(4),
      ),
      child: Stack(
        children: [
          NetworkImageWithLoader(image, radius: defaultBorderRadious),
          GetX<BookListController>(
            builder: (controller) {
              return controller.downloadingBooksData.containsKey(
                controller.books[index!].id,
              )
                  ? Center(
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: Stack(
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.grey,
                              value: controller
                                  .downloadingBooksData[
                                      controller.books[index!].id]!
                                  .downloadProgress,
                            ),
                            Center(
                              child: Text(
                                "${(controller.downloadingBooksData[controller.books[index!].id]!.downloadProgress * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          if (isPurchased)
            Positioned(
              left: defaultPadding / 2,
              top: defaultPadding / 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius:
                      BorderRadius.all(Radius.circular(defaultBorderRadious)),
                ),
                child: const Text(
                  'Purchased',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
        ],
      ),
    );
  }
}
