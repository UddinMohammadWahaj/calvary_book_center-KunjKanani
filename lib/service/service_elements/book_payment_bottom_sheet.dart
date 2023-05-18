import 'dart:developer';
import 'dart:math' as math;
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/service/digital_product_payment_service.dart';
import 'package:bookcenter/service/service_elements/apply_coupon_code.dart';
import 'package:bookcenter/service/service_elements/coupon_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BookPaymentBottomSheet extends StatefulWidget {
  const BookPaymentBottomSheet({
    Key? key,
    required this.book,
    required this.onPressedDownload,
  }) : super(key: key);

  final BookModel book;
  final VoidCallback onPressedDownload;

  @override
  State<BookPaymentBottomSheet> createState() => _BookPaymentBottomSheetState();
}

class _BookPaymentBottomSheetState extends State<BookPaymentBottomSheet> {
  @override
  void initState() {
    super.initState();
    Get.put(DigitalProductPaymentService()).isCouponApplied.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: ListView(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close),
            ),
          ),
          // const SizedBox(height: defaultPadding),
          AspectRatio(
            aspectRatio: 1.6,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.book.bookLogo!,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            'By ${widget.book.author}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: defaultPadding / 4),
          Text(
            widget.book.bookTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            widget.book.language != null &&
                    widget.book.language!.languageTitle.isNotEmpty
                ? widget.book.language!.languageTitle
                : '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: defaultPadding),
          Text(
            widget.book.description ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: defaultPadding / 4),
          const Divider(),
          const SizedBox(height: defaultPadding / 4),
          SizedBox(
            height: 30,
            child: widget.book.bookTags!.isEmpty
                ? const Center(
                    child: Text(
                      "No Tags Available",
                      style: TextStyle(),
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      widget.book.bookTags != null
                          ? widget.book.bookTags!.length
                          : 0,
                      (index) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2,
                          vertical: defaultPadding / 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin:
                            const EdgeInsets.only(right: defaultPadding / 2),
                        child: Center(
                          child: Text(
                            widget.book.bookTags![index],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: defaultPadding / 4),
          const Divider(),
          const SizedBox(height: defaultPadding / 4),
          // const Spacer(),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              Get.toNamed(
                calvaryPdfViewerScreenRoute,
                arguments: {
                  'book': widget.book,
                },
              );
            },
            child: widget.book.paymentStatus == 'N'
                ? const Text('View Preview')
                : widget.book.isDownloaded
                    ? const Text('Read Offline')
                    : const Text('Read Now'),
          ),
          const SizedBox(height: defaultPadding / 2),
          if (widget.book.paymentStatus == 'N')
            OutlinedButton(
              onPressed: () {
                var controller = Get.find<DigitalProductPaymentService>();
                controller.createBookPurchaseOrder(
                  book: widget.book,
                  paymentMadeFrom: PaymentMadeFrom.home,
                );
              },
              child: GetX<DigitalProductPaymentService>(
                builder: (controller) {
                  return controller.isPurchasingBook.value ||
                          controller.isApplyingCoupon.value
                      ? const SpinKitThreeBounce(
                          color: primaryColor,
                          size: 20.0,
                        )
                      : Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Buy Now ',
                              ),
                              if (controller.isCouponApplied.value)
                                TextSpan(
                                  text:
                                      '\u{20B9}${controller.discountedPrice.value} ',
                                  style: const TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              TextSpan(
                                text: '\u{20B9}${widget.book.price}',
                                style: TextStyle(
                                  decoration: controller.isCouponApplied.value
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontSize: controller.isCouponApplied.value
                                      ? 10
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          if (widget.book.paymentStatus == 'P' && !widget.book.isDownloaded)
            OutlinedButton(
              onPressed: widget.onPressedDownload,
              child: const Text('Download Now'),
            ),

          if (widget.book.paymentStatus == 'N')
            ApplyCouponCode(price: widget.book.price, type: 'book'),
          // Column(
          //   children: [
          //     const SizedBox(height: defaultPadding / 2),
          //     GetX<DigitalProductPaymentService>(
          //       builder: (controller) {
          //         return controller.isCouponApplied.value
          //             ? Row(
          //                 children: [
          //                   Transform.rotate(
          //                     angle: -math.pi / 4,
          //                     child: SvgPicture.asset(
          //                       "assets/icons/Coupon.svg",
          //                       color: Theme.of(context)
          //                           .inputDecorationTheme
          //                           .hintStyle!
          //                           .color!,
          //                     ),
          //                   ),
          //                   const SizedBox(width: defaultPadding),
          //                   Expanded(
          //                     child: Text.rich(
          //                       TextSpan(
          //                         text: "${controller.selectedCoupon.code}",
          //                         style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: primaryColor,
          //                         ),
          //                         children: const [
          //                           TextSpan(
          //                             text: " applied",
          //                             style: TextStyle(
          //                               fontWeight: FontWeight.normal,
          //                               color: blackColor40,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                   IconButton(
          //                     onPressed: () {
          //                       controller.removeCoupon();
          //                     },
          //                     icon: const Icon(Icons.close),
          //                   ),
          //                 ],
          //               )
          //             : OutlinedButton(
          //                 onPressed: () {
          //                   showModalBottomSheet(
          //                     context: context,
          //                     constraints: BoxConstraints(
          //                       minHeight: Get.height * 0.8,
          //                       maxHeight: Get.height * 0.8,
          //                     ),
          //                     isScrollControlled: true,
          //                     isDismissible: false,
          //                     enableDrag: false,
          //                     shape: const RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.only(
          //                         topLeft:
          //                             Radius.circular(defaultBorderRadious),
          //                         topRight:
          //                             Radius.circular(defaultBorderRadious),
          //                       ),
          //                     ),
          //                     builder: (context) => CouponBottomSheet(
          //                       type: 'book',
          //                       onApplyCoupon: (coupon) {
          //                         Get.back();
          //                         controller.applyCoupon(
          //                           coupon: coupon,
          //                           productPrice: widget.book.price,
          //                         );
          //                       },
          //                       // couponScrollController:
          //                       //     controller.couponScrollController,
          //                       // isApplyingCoupon:
          //                       //     controller.isApplyingCoupon.value,
          //                       // isFetchingCoupons:
          //                       //     controller.isFetchingCoupon.value,
          //                       // coupons: controller.coupons,
          //                     ),
          //                   );
          //                 },
          //                 child: const Text('Apply Coupon'),
          //               );
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
