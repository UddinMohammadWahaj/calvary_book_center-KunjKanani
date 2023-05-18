// import 'package:flutter/material.dart';
// import 'package:bookcenter/components/order_process.dart';
// import 'package:bookcenter/components/order_status_card.dart';
// import 'package:bookcenter/components/product/secondary_product_card.dart';
// import 'package:bookcenter/constants.dart';
// import 'package:bookcenter/models/product_model.dart';
// import 'package:bookcenter/route/screen_export.dart';

// class OrderProcessingScreen extends StatelessWidget {
//   const OrderProcessingScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Processing"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(defaultPadding),
//         child: Column(
//           children: [
//             OrderStatusCard(
//               press: () {
//                 Navigator.pushNamed(context, orderDetailsScreenRoute);
//               },
//               orderId: "FDS6398220",
//               placedOn: "Jun 10, 2021",
//               orderStatus: OrderProcessStatus.done,
//               processingStatus: OrderProcessStatus.processing,
//               // shippedStatus: OrderProcessStatus.notDoneYeat,
//               deliveredStatus: OrderProcessStatus.notDoneYeat,
//               products: List.generate(
//                 2,
//                 (index) => Padding(
//                   padding: const EdgeInsets.only(bottom: defaultPadding),
//                   child: SecondaryProductCard(
//                     id: -1,
//                     image: demoPopularProducts[index].image,
//                     brandName: demoPopularProducts[index].brandName,
//                     title: demoPopularProducts[index].title,
//                     price: demoPopularProducts[index].price,
//                     priceAfetDiscount:
//                         demoPopularProducts[index].priceAfetDiscount,
//                     style: ElevatedButton.styleFrom(
//                       maximumSize: const Size(double.infinity, 90),
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
