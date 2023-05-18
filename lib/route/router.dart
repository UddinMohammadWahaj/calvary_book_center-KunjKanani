import 'package:bookcenter/screens/albums/views/album_player.dart';
import 'package:bookcenter/screens/albums/views/albums_list_screen.dart';
import 'package:bookcenter/screens/albums/views/albums_view.dart';
import 'package:bookcenter/screens/bookstore/views/book_list_screen.dart';
import 'package:bookcenter/screens/bookstore/views/calvary_pdf_viewer.dart';
import 'package:bookcenter/screens/checkout/views/order_fail_screen.dart';
import 'package:bookcenter/screens/checkout/views/order_screen.dart';
import 'package:bookcenter/screens/checkout/views/select_address_screen.dart';
import 'package:bookcenter/screens/daily_promises/views/daily_promises_screen.dart';
import 'package:bookcenter/screens/order/views/order_list.dart';
import 'package:bookcenter/screens/product_list/views/product_display_screen.dart';

import 'package:bookcenter/entry_point.dart';
import 'package:bookcenter/screens/checkout/views/thanks_for_order_screen.dart';
import 'package:bookcenter/screens/payment/views/add_new_card_screen.dart';
import 'package:bookcenter/screens/sermons/views/sermon_view_screen.dart';
import 'package:bookcenter/screens/sermons/views/sermons_list_screen.dart';
import 'package:bookcenter/screens/sermons/views/video_player_screen.dart';
import 'package:bookcenter/screens/sermons/views/youtube_player_screen.dart';
import 'package:bookcenter/splash_screen.dart';
import 'package:get/get.dart';
import 'screen_export.dart';

List<GetPage> getXRouterPages() {
  return [
    GetPage(
      name: splashScreenRoute,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: onbordingScreenRoute,
      page: () => const OnBordingScreen(),
    ),
    GetPage(
      name: notificationPermissionScreenRoute,
      page: () => const NotificationPermissionScreen(),
    ),
    GetPage(
      name: logInScreenRoute,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: signUpScreenRoute,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: profileSetupScreenRoute,
      page: () => const ProfileSetupScreen(),
    ),
    GetPage(
      name: passwordRecoveryScreenRoute,
      page: () => const PasswordRecoveryScreen(),
    ),
    GetPage(
      name: verificationMethodScreenRoute,
      page: () => const VerificationMethodScreen(),
    ),
    GetPage(
      name: otpScreenRoute,
      page: () => const OtpScreen(),
    ),
    GetPage(
      name: newPasswordScreenRoute,
      page: () => const SetNewPasswordScreen(),
    ),
    GetPage(
      name: doneResetPasswordScreenRoute,
      page: () => const DoneResetPasswordScreen(),
    ),
    GetPage(
      name: termsOfServicesScreenRoute,
      page: () => const TermsOfServicesScreen(),
    ),
    GetPage(
      name: noInternetScreenRoute,
      page: () => const NoInternetScreen(),
    ),
    GetPage(
      name: serverErrorScreenRoute,
      page: () => const ServerErrorScreen(),
    ),
    GetPage(
      name: signUpVerificationScreenRoute,
      page: () => const SignUpVerificationScreen(),
    ),
    GetPage(
      name: setupFingerprintScreenRoute,
      page: () => const SetupFingerprintScreen(),
    ),
    GetPage(
      name: setupFaceIdScreenRoute,
      page: () => const SetupFaceIdScreen(),
    ),
    GetPage(
      name: productDetailsScreenRoute,
      page: () => const ProductDetailsScreen(),
    ),
    GetPage(
      name: productReviewsScreenRoute,
      page: () => const ProductReviewsScreen(),
    ),
    GetPage(
      name: addReviewsScreenRoute,
      page: () => const AddReviewScreen(),
    ),
    GetPage(
      name: homeScreenRoute,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: brandScreenRoute,
      page: () => const BrandScreen(),
    ),
    GetPage(
      name: productListScreenRoute,
      page: () => ProductDisplayScreen(),
    ),
    GetPage(
      name: kidsScreenRoute,
      page: () => const KidsScreen(),
    ),
    GetPage(
      name: searchScreenRoute,
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: searchHistoryScreenRoute,
      page: () => const SearchHistoryScreen(),
    ),
    GetPage(
      name: bookmarkScreenRoute,
      page: () => const BookmarkScreen(),
    ),
    GetPage(
      name: entryPointScreenRoute,
      page: () => const EntryPoint(),
    ),
    GetPage(
      name: dailyPromisesScreenRoute,
      page: () => const DailyPromisesScreen(),
    ),
    GetPage(
      name: profileScreenRoute,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: getHelpScreenRoute,
      page: () => const GetHelpScreen(),
    ),
    GetPage(
      name: chatScreenRoute,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: userInfoScreenRoute,
      page: () => const UserInfoScreen(),
    ),
    GetPage(
      name: currentPasswordScreenRoute,
      page: () => const CurrentPasswordScreen(),
    ),
    GetPage(
      name: editUserInfoScreenRoute,
      page: () => const EditUserInfoScreen(),
    ),
    GetPage(
      name: notificationsScreenRoute,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: noNotificationScreenRoute,
      page: () => const NoNotificationScreen(),
    ),
    GetPage(
      name: enableNotificationScreenRoute,
      page: () => const EnableNotificationScreen(),
    ),
    GetPage(
      name: notificationOptionsScreenRoute,
      page: () => const NotificationOptionsScreen(),
    ),
    GetPage(
      name: noAddressScreenRoute,
      page: () => const NoAddressScreen(),
    ),
    GetPage(
      name: addressesScreenRoute,
      page: () => const AddressesScreen(),
    ),
    GetPage(
      name: addNewAddressesScreenRoute,
      page: () => const AddNewAddressScreen(),
    ),
    GetPage(
      name: ordersScreenRoute,
      page: () => const OrdersScreen(),
    ),
    GetPage(
      name: orderListScreenRoute,
      page: () => const OrderListScreen(),
    ),
    GetPage(
      name: orderDetailsScreenRoute,
      page: () => const OrderDetailsScreen(),
    ),
    GetPage(
      name: preferencesScreenRoute,
      page: () => const PreferencesScreen(),
    ),
    GetPage(
      name: emptyPaymentScreenRoute,
      page: () => const EmptyPaymentScreen(),
    ),
    GetPage(
      name: cartScreenRoute,
      page: () => const CartScreen(),
    ),
    GetPage(
      name: selectAddressScreenRoute,
      page: () => SelectAddressScreen(),
    ),
    GetPage(
      name: paymentProcessingScreenRoute,
      page: () => const PaymentProcessingScreen(),
    ),
    GetPage(
      name: paymentMethodScreenRoute,
      page: () => const PaymentMethodScreen(),
    ),
    GetPage(
      name: addNewCardScreenRoute,
      page: () => const AddNewCardScreen(),
    ),
    GetPage(
      name: thanksForOrderScreenRoute,
      page: () => const ThanksForOrderScreen(),
    ),
    GetPage(
      name: paymentFailScreenRoute,
      page: () => const PaymentFailScreen(),
    ),
    GetPage(
      name: albumViewScreenRoute,
      page: () => AlbumView(),
    ),
    GetPage(
      name: youtubePlayerScreenRoute,
      page: () => const YoutubePlayerScreen(),
    ),
    GetPage(
      name: bookStoreCategoryScreenRoute,
      page: () => const BookStoreCategoryScreen(),
    ),
    GetPage(
      name: bookListScreenRoute,
      page: () => const BookListScreen(),
    ),
    GetPage(
      name: calvaryPdfViewerScreenRoute,
      page: () => const CalvaryPdfViewer(),
    ),
    GetPage(
      name: albumsListScreenRoute,
      page: () => const AlbumsListScreen(),
    ),
    GetPage(
      name: albumPlayerScreenRoute,
      page: () => const AlbumPlayerScreen(),
    ),
    GetPage(
      name: sermonsListScreenRoute,
      page: () => const SermonsListScreen(),
    ),
    GetPage(
      name: sermonViewScreenRoute,
      page: () => SermonsViewScreen(),
    ),
    GetPage(
      name: videoPlayerScreenRoute,
      page: () => const VideoPlayerScreen(),
    ),
  ];
}
