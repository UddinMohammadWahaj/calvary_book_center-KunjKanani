import 'package:bookcenter/screens/home/views/components/lastest_albums.dart';
import 'package:bookcenter/service/service_elements/player_widget.dart';
import 'package:flutter/material.dart';

import 'components/offer_carousel_and_categories.dart';
import 'components/popular_book.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: MusicPlayerTile(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            SliverToBoxAdapter(child: Popularbooks()),
            SliverPadding(padding: EdgeInsets.all(10)),
            SliverToBoxAdapter(child: LatestAlbumsCarousel()),
            // const SliverPadding(
            //   padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
            //   sliver: SliverToBoxAdapter(child: FlashSale()),
            // ),
            // SliverToBoxAdapter(child: AlbumsCarousel()),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       // While loading use 👇
            //       // const BannerMSkelton(),
            //       BannerSStyle1(
            //         title: "New \narrival",
            //         subtitle: "SPECIAL OFFER",
            //         discountParcent: 50,
            //         press: () {
            //           Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //       const SizedBox(height: defaultPadding / 4),
            //       // While loading use 👇
            //       //  const BannerMSkelton(),
            //       BannerSStyle4(
            //         title: "SUMMER \nSALE",
            //         subtitle: "SPECIAL OFFER",
            //         bottomText: "UP TO 80% OFF",
            //         press: () {
            //           Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //       const SizedBox(height: defaultPadding / 4),
            //       // While loading use 👇
            //       //  const BannerMSkelton(),
            //       BannerSStyle4(
            //         image: "https://i.imgur.com/dBrsD0M.png",
            //         title: "Black \nfriday",
            //         subtitle: "50% off",
            //         bottomText: "Collection".toUpperCase(),
            //         press: () {
            //           Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // const SliverToBoxAdapter(child: BestSellers()),
            // const SliverToBoxAdapter(child: MostPopular()),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       const SizedBox(height: defaultPadding * 1.5),
            //       // While loading use 👇
            //       // const BannerLSkelton(),
            //       BannerLStyle1(
            //         title: "Summer \nSale",
            //         subtitle: "SPECIAL OFFER",
            //         discountPercent: 50,
            //         press: () {
            //           Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //       const SizedBox(height: defaultPadding / 4),
            //       // While loading use 👇
            //       // const BannerSSkelton(),
            //       BannerSStyle5(
            //         title: "Black \nfriday",
            //         subtitle: "50% Off",
            //         bottomText: "Collection".toUpperCase(),
            //         press: () {
            //           Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //       const SizedBox(height: defaultPadding / 4),
            //       // While loading use 👇
            //       // const BannerSSkelton(),
            //       BannerSStyle5(
            //         image: "https://i.imgur.com/2443sJb.png",
            //         title: "Grab \nyours now",
            //         subtitle: "65% Off",
            //         press: () {
            //           Navigator.pushNamed(context, onSaleScreenRoute);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // const SliverToBoxAdapter(child: BestSellers()),
          ],
        ),
      ),
    );
  }
}
