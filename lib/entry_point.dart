import 'package:animations/animations.dart';
import 'package:bookcenter/screens/download/views/download_view.dart';
import 'package:bookcenter/service/entry_point_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:get/get.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final List _pages = const [
    HomeScreen(),
    ShopScreen(),
    // BookmarkScreen(),
    DownloadScreen(),
    // EmptyCartScreen(), // if Cart is empty
    CartScreen(),
    ProfileScreen(),
  ];
  // int _currentIndex = 0;

  Widget svgIcon(String src, {Color? color}) {
    return src.contains('svg')
        ? SvgPicture.asset(
            src,
            height: 24,
            color: color ??
                Theme.of(context).iconTheme.color!.withOpacity(
                      Theme.of(context).brightness == Brightness.dark ? 0.3 : 1,
                    ),
          )
        : Image.asset(
            src,
            height: 30,
            color: color ??
                Theme.of(context).iconTheme.color!.withOpacity(
                      Theme.of(context).brightness == Brightness.dark ? 0.3 : 1,
                    ),
          );
  }

  @override
  void initState() {
    super.initState();
    Get.put(EntryPointService()).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        // floating: true,
        // snap: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        // title: SvgPicture.asset(
        //   "assets/logo/Shoplon.svg",
        //   color: Theme.of(context).iconTheme.color,
        //   height: 20,
        //   width: 100,
        // ),
        title: Text(
          "Calvary Book Center",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(searchScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed(notificationsScreenRoute);
              // CacheService.instance.deleteAllDataFromCache();
            },
            icon: SvgPicture.asset(
              "assets/icons/Notification.svg",
              height: 24,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      ),
      // body: _pages[_currentIndex],
      body: GetX<EntryPointService>(
        init: EntryPointService(),
        builder: (entryPointService) {
          return entryPointService.isFetchingStatus.value
              ? Center(
                  child: SpinKitThreeBounce(
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                )
              : PageTransitionSwitcher(
                  duration: defaultDuration,
                  transitionBuilder: (child, animation, secondAnimation) {
                    return FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondAnimation,
                      child: child,
                    );
                  },
                  child: _pages[entryPointService.currentPage.value],
                );
        },
      ),
      bottomNavigationBar: GetX<EntryPointService>(
        builder: (entryPointService) {
          return Container(
            padding: const EdgeInsets.only(top: defaultPadding / 2),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : const Color(0xFF101015),
            child: BottomNavigationBar(
              currentIndex: entryPointService.currentPage.value,
              onTap: (index) {
                if (index != entryPointService.currentPage.value) {
                  entryPointService.currentPage.value = index;
                }
              },
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF101015),
              type: BottomNavigationBarType.fixed,
              // selectedLabelStyle: TextStyle(color: primaryColor),
              selectedFontSize: 12,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.transparent,
              items: [
                BottomNavigationBarItem(
                  icon: svgIcon("assets/icons/Category.svg"),
                  activeIcon: svgIcon(
                    "assets/icons/Category.svg",
                    color: primaryColor,
                  ),
                  label: "Discover",
                ),
                BottomNavigationBarItem(
                  icon: svgIcon("assets/icons/Bag.svg"),
                  activeIcon: svgIcon(
                    "assets/icons/Bag.svg",
                    color: primaryColor,
                  ),
                  label: "Shop",
                ),
                // BottomNavigationBarItem(
                //   icon: svgIcon("assets/icons/Bookmark.svg"),
                //   activeIcon: svgIcon(
                //     "assets/icons/Bookmark.svg",
                //     color: primaryColor,
                //   ),
                //   label: "Bookmark",
                // ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.cloud_download,
                    color: Theme.of(context).iconTheme.color!.withOpacity(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.3
                              : 1,
                        ),
                    size: 26,
                  ),
                  activeIcon: const Icon(
                    CupertinoIcons.cloud_download,
                    color: primaryColor,
                    size: 26,
                  ),
                  label: "Download",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.cart,
                    color: Theme.of(context).iconTheme.color!.withOpacity(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.3
                              : 1,
                        ),
                    size: 24,
                  ),
                  activeIcon: const Icon(
                    CupertinoIcons.cart,
                    color: primaryColor,
                    size: 24,
                  ),
                  label: "Cart",
                ),
                BottomNavigationBarItem(
                  icon: svgIcon("assets/icons/Profile.svg"),
                  activeIcon: svgIcon(
                    "assets/icons/Profile.svg",
                    color: primaryColor,
                  ),
                  label: "Profile",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
