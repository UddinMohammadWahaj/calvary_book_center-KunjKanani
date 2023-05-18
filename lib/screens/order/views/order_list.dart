import 'package:bookcenter/components/skleton/others/order_status_card.dart';
import 'package:bookcenter/screens/checkout/views/empty_screen.dart';
import 'package:bookcenter/screens/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:bookcenter/components/order_process.dart';
import 'package:bookcenter/components/order_status_card.dart';
import 'package:bookcenter/components/product/secondary_product_card.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<OrderController>(
          init: OrderController(),
          builder: (controller) {
            return Text(controller.orderStatus.value.asString);
          },
        ),
      ),
      body: GetX<OrderController>(
        init: OrderController(),
        builder: (controller) {
          return controller.orders.isEmpty && !controller.isFetchingOrder.value
              ? const EmptyScreen(
                  title: 'No Orders Found',
                )
              : ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.isFetchingOrder.value
                      ? controller.orders.length + 1
                      : controller.orders.length,
                  itemBuilder: (context, index) {
                    // // log(controller.orders[index].orderDate);
                    if (index >= controller.orders.length) {
                      return const OrderStatusCardSkelton();
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2,
                      ),
                      child: OrderStatusCard(
                        press: () {
                          Get.toNamed(
                            orderDetailsScreenRoute,
                            arguments: {
                              'order': controller.orders[index],
                              'status': controller.orderStatus.value,
                            },
                          );
                        },
                        orderId: controller.orders[index].id.toString(),
                        placedOn: DateFormat('yMMMMd').format(
                          DateTime.parse(controller.orders[index].orderDate),
                        ),
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
                        products: List.generate(
                          controller.orders[index].items.length,
                          (itemIndex) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: defaultPadding),
                            child: SecondaryProductCard(
                              id: controller
                                  .orders[index].items[itemIndex].productId,
                              image: controller
                                  .orders[index].items[itemIndex].productImage,
                              brandName: 'Calvary',
                              title: controller
                                  .orders[index].items[itemIndex].productName,
                              price: double.parse(
                                controller.orders[index].items[itemIndex].price
                                    .toString(),
                              ),
                              priceAfetDiscount: double.parse(
                                controller.orders[index].items[itemIndex].price
                                    .toString(),
                              ),
                              quantity: controller
                                  .orders[index].items[itemIndex].quantity,
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(double.infinity, 90),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
