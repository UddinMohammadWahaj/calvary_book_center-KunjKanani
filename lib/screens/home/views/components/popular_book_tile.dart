import 'package:bookcenter/components/network_image_with_loader.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularBookTile extends StatelessWidget {
  const PopularBookTile({
    Key? key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    required this.id,
    required this.press,
    this.isPurchased = false,
  }) : super(key: key);
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent, id;
  final VoidCallback press;
  final bool? isPurchased;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: OutlinedButton(
        onPressed: press,
        style: OutlinedButton.styleFrom(
          // minimumSize: const Size(150, 220),
          // maximumSize: const Size(150, 220),
          padding: const EdgeInsets.all(6),
        ),
        child: Stack(
          children: [
            NetworkImageWithLoader(image, radius: defaultBorderRadious),
            GetX<HomeController>(
              builder: (controller) {
                return controller.downloadingBooksData.containsKey(
                  id,
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
                                    .downloadingBooksData[id]!.downloadProgress,
                              ),
                              Center(
                                child: Text(
                                  "${(controller.downloadingBooksData[id]!.downloadProgress * 100).toStringAsFixed(0)}%",
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
            if (dicountpercent != null)
              Positioned(
                right: defaultPadding / 2,
                top: defaultPadding / 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  height: 16,
                  decoration: const BoxDecoration(
                    color: errorColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultBorderRadious)),
                  ),
                  child: Text(
                    "$dicountpercent% off",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            if (isPurchased ?? false)
              Positioned(
                left: defaultPadding / 2,
                top: defaultPadding / 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
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
      ),
    );
  }
}
