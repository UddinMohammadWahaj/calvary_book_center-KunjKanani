import 'package:flutter/material.dart';

import '../constants.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key? key,
    required this.price,
    required this.quantity,
    this.title = "Buy Now",
    this.subTitle = "Unit price",
    required this.press,
  }) : super(key: key);

  final double price;
  final String title, subTitle;
  final VoidCallback press;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultBorderRadious / 2),
        child: SizedBox(
          height: 64,
          child: Material(
            color: primaryColor,
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(defaultBorderRadious),
              ),
            ),
            child: InkWell(
              onTap: press,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${price.toStringAsFixed(2)} ₹",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            subTitle,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.15),
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),

                  //     child: const SizedBox(
                  //       height: 20,
                  //       width: 20,
                  //       child: CircularProgressIndicator(
                  //         strokeWidth: 2,
                  //         valueColor:
                  //             AlwaysStoppedAnimation<Color>(Colors.white),
                  //       ),
                  //     ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
