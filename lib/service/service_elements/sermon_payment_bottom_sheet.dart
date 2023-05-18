import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/service/digital_product_payment_service.dart';
import 'package:bookcenter/service/service_elements/apply_coupon_code.dart';
import 'package:bookcenter/service/service_elements/coupon_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SermonPaymentBottomSheet extends StatefulWidget {
  const SermonPaymentBottomSheet({super.key, required this.sermonModel});

  final SermonModel sermonModel;

  @override
  State<SermonPaymentBottomSheet> createState() =>
      _SermonPaymentBottomSheetState();
}

class _SermonPaymentBottomSheetState extends State<SermonPaymentBottomSheet> {
  @override
  void initState() {
    super.initState();

    Get.put(DigitalProductPaymentService()).isCouponApplied.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: defaultPadding),
          Hero(
            tag: widget.sermonModel.sermonsLogo ?? '',
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.sermonModel.sermonsLogo ?? '',
                  width: Get.width / 2,
                  height: Get.width / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            'By ${widget.sermonModel.sermonsArtist}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: defaultPadding / 4),
          Text(
            widget.sermonModel.sermonsTitle ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            "${widget.sermonModel.videoSongs.length} Songs",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: defaultPadding / 4),
          const Divider(),
          const SizedBox(height: defaultPadding / 4),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...widget.sermonModel.videoSongs
                    .map(
                      (e) => Column(
                        children: [
                          ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(
                                defaultPadding / 1.5,
                              ),
                              child: Icon(
                                Icons.music_note,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(
                              e.songTitle ?? '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              var controller = Get.find<DigitalProductPaymentService>();
              controller.createSermonPurchaseOrder(sermon: widget.sermonModel);
            },
            child: GetX<DigitalProductPaymentService>(
              builder: (controller) {
                return controller.isPurchasingSermon.value ||
                        controller.isApplyingCoupon.value
                    ? const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 20,
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
                              text: '\u{20B9}${widget.sermonModel.price}',
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
          if (widget.sermonModel.paymentStatus == 'N' &&
              widget.sermonModel.paymentType == 'PAID')
            ApplyCouponCode(price: widget.sermonModel.price, type: 'videoalbum')
          // Column(
          //   children: [
          //     const SizedBox(height: defaultPadding / 2),
          //     OutlinedButton(
          //       onPressed: () {
          //         showModalBottomSheet(
          //           context: context,
          //           constraints: BoxConstraints(
          //             minHeight: Get.height * 0.8,
          //             maxHeight: Get.height * 0.8,
          //           ),
          //           isScrollControlled: true,
          //           isDismissible: false,
          //           enableDrag: false,
          //           shape: const RoundedRectangleBorder(
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(defaultBorderRadious),
          //               topRight: Radius.circular(defaultBorderRadious),
          //             ),
          //           ),
          //           builder: (context) => GetX<DigitalProductPaymentService>(
          //             builder: (controller) {
          //               return CouponBottomSheet(
          //                 type: 'videoalbum',
          //                 onApplyCoupon: (coupon) {
          //                   Get.back();
          //                   controller.applyCoupon(
          //                     coupon: coupon,
          //                     productPrice: widget.sermonModel.price,
          //                   );
          //                 },

          //               );
          //             },
          //           ),
          //         );
          //       },
          //       child: const Text('Apply Coupon'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
