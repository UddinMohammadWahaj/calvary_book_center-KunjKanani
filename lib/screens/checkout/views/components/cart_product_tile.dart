import 'package:bookcenter/components/network_image_with_loader.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/checkout/controllers/cart_controller.dart';
import 'package:bookcenter/screens/product_list/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartProductTile extends StatelessWidget {
  const CartProductTile({
    Key? key,
    required this.image,
    this.brandName = '',
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.press,
    this.style,
    required this.product,
  }) : super(key: key);
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final VoidCallback? press;
  final ButtonStyle? style;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: style ??
          OutlinedButton.styleFrom(
            minimumSize: const Size(256, 114),
            maximumSize: const Size(256, 114),
            padding: EdgeInsets.zero,
          ),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                NetworkImageWithLoader(image, radius: defaultBorderRadious),
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
                        borderRadius: BorderRadius.all(
                            Radius.circular(defaultBorderRadious)),
                      ),
                      child: Text(
                        "$dicountpercent% off",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(width: defaultPadding / 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   brandName.toUpperCase(),
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .bodyText2!
                  //       .copyWith(fontSize: 10),
                  // ),
                  // const SizedBox(height: defaultPadding / 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  priceAfetDiscount != price
                      ? Row(
                          children: [
                            Text(
                              "$priceAfetDiscount ₹",
                              style: const TextStyle(
                                color: Color(0xFF31B0D8),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: defaultPadding / 4),
                            Text(
                              "$price ₹",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "$price ₹",
                          style: const TextStyle(
                            color: Color(0xFF31B0D8),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),

                  // QuantityCounter increase and decrease button
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    children: [
                      Container(
                        width: 90,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(defaultBorderRadious / 2),
                          ),
                          border: Border.all(color: blackColor20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                onPressed: product.buyingQuantity! > 1
                                    ? () {
                                        Get.find<CartController>()
                                            .decreaseQuantity(product);
                                      }
                                    : null,
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.remove,
                                  size: 12,
                                ),
                              ),
                            ),
                            Text(
                              product.buyingQuantity.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontSize: 12),
                            ),
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                onPressed: () {
                                  Get.find<CartController>()
                                      .increaseQuantity(product);
                                },
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.add,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.find<CartController>().removeItem(product);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: errorColor,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
