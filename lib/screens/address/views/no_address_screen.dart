import 'package:bookcenter/route/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NoAddressScreen extends StatelessWidget {
  const NoAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Address"),
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: SvgPicture.asset(
      //         "assets/icons/DotsV.svg",
      //         color: Theme.of(context).iconTheme.color,
      //       ),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          const Spacer(flex: 2),
          // Image.asset(
          //   Theme.of(context).brightness == Brightness.light
          //       ? "assets/Illustration/EmptyState_lightTheme.png"
          //       : "assets/Illustration/EmptyState_darkTheme.png",
          //   width: MediaQuery.of(context).size.width * 0.6,
          // ),
          LottieBuilder.asset(
            'assets/lottie/no-found-candles.json',
          ),
          const Spacer(),
          Text(
            "No Address found",
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: defaultPadding),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: defaultPadding * 1.5),
          //   child: Text(
          //     "Enabling push notifications allows us to send you info about our new products, sales, events and more!",
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(addNewAddressesScreenRoute);
              },
              child: const Text("Add address"),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
