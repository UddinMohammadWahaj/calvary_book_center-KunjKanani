import 'package:bookcenter/screens/order/controllers/order_controller.dart';
import 'package:bookcenter/screens/order/controllers/order_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/order_process.dart';
import 'package:bookcenter/components/order_status_card.dart';
import 'package:bookcenter/components/product/secondary_product_card.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'components/help_line.dart';
import 'components/order_summary_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order detail"),
      ),
      body: GetX<OrderDetailController>(
        init: OrderDetailController(),
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: OrderStatusCard(
                      orderId: controller.currentSelectedOrder.transactionId
                          .replaceAll('pay_', ''),
                      placedOn: DateFormat('yMMMMd').format(DateTime.parse(
                        controller.currentSelectedOrder.orderDate,
                      )),
                      orderStatus: OrderProcessStatus.done,
                      processingStatus: controller.orderStatus.value ==
                              OrderProcessState.processing
                          ? OrderProcessStatus.processing
                          : controller.orderStatus.value ==
                                  OrderProcessState.success
                              ? OrderProcessStatus.done
                              : OrderProcessStatus.error,
                      deliveredStatus: controller.orderStatus.value ==
                              OrderProcessState.processing
                          ? OrderProcessStatus.notDoneYeat
                          : controller.orderStatus.value ==
                                  OrderProcessState.success
                              ? OrderProcessStatus.done
                              : OrderProcessStatus.error,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery address",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: defaultPadding / 2),
                              Text(controller.currentSelectedOrder.address)
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       Text(
                        //         "Estimated time",
                        //         style: Theme.of(context).textTheme.subtitle2,
                        //       ),
                        //       const SizedBox(height: defaultPadding / 2),
                        //       const Text(
                        //         "Today \n9 AM to 10 AM",
                        //         textAlign: TextAlign.end,
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      "Products",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ...List.generate(
                    controller.currentSelectedOrder.items.length,
                    (itemIndex) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2,
                      ),
                      child: SecondaryProductCard(
                        id: controller
                            .currentSelectedOrder.items[itemIndex].productId,
                        image: controller
                            .currentSelectedOrder.items[itemIndex].productImage,
                        brandName: 'Calvary',
                        title: controller
                            .currentSelectedOrder.items[itemIndex].productName,
                        price: double.parse(
                          controller.currentSelectedOrder.items[itemIndex].price
                              .toString(),
                        ),
                        priceAfetDiscount: double.parse(
                          controller.currentSelectedOrder.items[itemIndex].price
                              .toString(),
                        ),
                        style: ElevatedButton.styleFrom(
                          maximumSize: const Size(double.infinity, 90),
                          padding: EdgeInsets.zero,
                        ),
                        quantity: controller
                            .currentSelectedOrder.items[itemIndex].quantity,
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Divider(height: 1),
                  // ProfileMenuListTile(
                  //   svgSrc: "assets/icons/Delivery.svg",
                  //   text: "View shipment",
                  //   press: () {},
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: OrderSummaryCard(
                      subTotal: controller.currentSelectedOrder.totalAmount -
                          controller.currentSelectedOrder.tip,
                      totalWithTaxes:
                          controller.currentSelectedOrder.totalAmount,
                      tip: controller.currentSelectedOrder.tip,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                    child: HelpLine(number: "+91-9392229996"),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(defaultPadding),
                  //   child: OutlinedButton(
                  //     onPressed: () {
                  //       // Navigator.pushNamed(context, cancleOrderScreenRoute);
                  //     },
                  //     child: Text(
                  //       "Cancel order",
                  //       style: TextStyle(
                  //           color: Theme.of(context).textTheme.bodyText1!.color!),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
