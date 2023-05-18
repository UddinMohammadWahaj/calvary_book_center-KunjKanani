import 'dart:async';
import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/models/download_model.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/screens/albums/repositories/album_repository.dart';
import 'package:bookcenter/screens/bookstore/repositories/book_store_reposotory.dart';
import 'package:bookcenter/screens/home/models/upcoming_event.dart';
import 'package:bookcenter/screens/home/repositories/home_repository.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/screens/sermons/repositories/sermon_repository.dart';
import 'package:bookcenter/service/download_service.dart';
import 'package:bookcenter/service/entry_point_service.dart';
import 'package:bookcenter/service/service_elements/album_payment_bottom_sheet.dart';
import 'package:bookcenter/service/service_elements/book_payment_bottom_sheet.dart';
import 'package:bookcenter/service/service_elements/sermon_payment_bottom_sheet.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final isFetchingUpcomingEvents = false.obs,
      isFetchingLastestAlbum = false.obs,
      isFetchingLastestBooks = false.obs;

  List<UpcomingEvent> upcomingEvents = [];
  List<AlbumModel> lastestAlbums = [];
  List<BookModel> lastestBooks = [];
  final PageController upcomingEventPageController = PageController(
        initialPage: 0,
      ),
      lastestAlbumPageController = PageController(
        initialPage: 0,
      );
  late Timer timer1;
  var currentUpcomingEvent = 0.obs, currentLastestAlbum = 0.obs;
  var entryPointService = Get.find<EntryPointService>();

  final secureFileStorageService = Get.find<SecureFileStorageService>();

  final downloadingBooksData = <int, DownloadingModel>{}.obs;
  final _downloadService = Get.find<DownloadService>();

  @override
  void onInit() async {
    super.onInit();
    fetchUpcomingEvents();
    fetchLatestAlbums();
    fetchLatestBooks();
    listenToDownloadingQueue();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initPageController();
    });
  }

  @override
  void onClose() {
    timer1.cancel();
    upcomingEventPageController.dispose();
    lastestAlbumPageController.dispose();
    super.onClose();
  }

  Future fetchUpcomingEvents() async {
    isFetchingUpcomingEvents.value = true;

    ApiResponse apiResponse =
        await HomeRespository.instance.fetchUpcomingEvents();

    if (apiResponse.message == ApiMessage.success) {
      upcomingEvents = apiResponse.data;
    } else {
      Get.snackbar('Error', apiResponse.data ?? 'Something went wrong');
    }

    isFetchingUpcomingEvents.value = false;
  }

  Future fetchLatestAlbums() async {
    isFetchingLastestAlbum.value = true;

    ApiResponse apiResponse =
        await HomeRespository.instance.fetchLastestAlbums();

    if (apiResponse.message == ApiMessage.success) {
      lastestAlbums = apiResponse.data;
    } else {
      Get.snackbar('Error', apiResponse.data.toString());
    }

    isFetchingLastestAlbum.value = false;
  }

  void initPageController() {
    entryPointService.currentPage.listenAndPump((page) async {
      if (page != 0) {
        timer1.cancel();
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100), () {
        if (lastestAlbums.isNotEmpty) {
          lastestAlbumPageController.jumpToPage(currentLastestAlbum.value);
        }

        if (upcomingEvents.isNotEmpty) {
          upcomingEventPageController.jumpToPage(currentUpcomingEvent.value);
        }
      });

      if (page == 0) {
        timer1 = Timer.periodic(
          const Duration(seconds: 3),
          (timer) {
            updateCarousalOne();
            updateCarousalTwo();
          },
        );
      } else {
        timer1.cancel();
      }
    });
  }

  void updateCarousalOne() {
    if (currentUpcomingEvent.value < upcomingEvents.length - 1) {
      currentUpcomingEvent.value++;
    } else {
      currentUpcomingEvent.value = 0;
    }

    upcomingEventPageController.animateToPage(
      currentUpcomingEvent.value,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void updateCarousalTwo() {
    if (currentLastestAlbum.value < lastestAlbums.length - 1) {
      currentLastestAlbum.value++;
    } else {
      currentLastestAlbum.value = 0;
    }

    lastestAlbumPageController.animateToPage(
      currentLastestAlbum.value,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  fetchLatestBooks() async {
    isFetchingLastestBooks.value = true;

    ApiResponse apiResponse =
        await HomeRespository.instance.fetchLastestBooks();

    if (apiResponse.message == ApiMessage.success) {
      lastestBooks = apiResponse.data;
      await refreshDownloads();
    } else {
      // log(apiResponse.data.toString());
      // Get.snackbar('Error', apiResponse.data.toString());
    }

    isFetchingLastestBooks.value = false;
  }

  Future<bool> isFileExistLocally(int fileId, String fileName) async {
    return await secureFileStorageService.isFileExist(
      fileId: fileId,
      fileType: FileType.book,
      fileName: fileName,
    );
  }

  void listenToDownloadingQueue() {
    _downloadService.downloadingQueue.listenAndPump((event) {
      if (event.isEmpty) {
        downloadingBooksData.clear();
      } else {
        downloadingBooksData.clear();
        for (var element in event) {
          if (element.fileType == FileType.book) {
            downloadingBooksData[element.id] = element;
          }
        }
      }
      downloadingBooksData.refresh();
    });
  }

  void downloadBook({
    required int bookId,
    required String bookUrl,
    required String bookName,
  }) {
    _downloadService.addFileToDownloadingQueue(
      id: bookId,
      fileType: FileType.book,
      url: bookUrl,
      fileName: bookName,
      onDownloadCompleted: () {
        for (var element in lastestBooks) {
          if (element.id == bookId) {
            element.isDownloaded = true;
          }
        }
      },
    );
  }

  Future refreshDownloads() async {
    for (BookModel element in lastestBooks) {
      if (await isFileExistLocally(element.id, element.bookTitle)) {
        element.isDownloaded = true;
      } else {
        element.isDownloaded = false;
      }
    }
  }

  void updateBookPayment({required int id, required String status}) {
    for (var element in lastestBooks) {
      if (element.id == id) {
        element.paymentStatus = status;
      }
    }
  }

  void handleUpcomingEventClick({
    required int index,
    required UpcomingEvent upcomingEvent,
    required BuildContext context,
  }) async {
    if (!upcomingEvents[index].navigationStatus!) {
      return;
    }
    Get.dialog(
      Center(
        child: Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );

    if (upcomingEvents[index].productName == 'product | product') {
      Get.back();
      Get.toNamed(
        productDetailsScreenRoute,
        arguments: {
          'productId': upcomingEvents[index].productId,
        },
      );
    } else if (upcomingEvents[index].productName == 'product | category') {
      Get.back();
      entryPointService.currentPage.value = 1;
    } else if (upcomingEvents[index].productName == 'product | subcategory') {
      Get.back();
      entryPointService.currentPage.value = 1;
    } else if (upcomingEvents[index].productName == 'bookcenter | album') {
      _handleAlbum(albumId: upcomingEvents[index].productId!, context: context);
    } else if (upcomingEvents[index].productName == 'bookcenter | book') {
      BookModel? bookModel = await _fetchBook(upcomingEvents[index].productId);

      if (bookModel != null) {
        var fileExists = await secureFileStorageService.isFileExist(
          fileId: bookModel.id,
          fileType: FileType.book,
          fileName: bookModel.bookTitle,
        );
        if (fileExists) {
          bookModel.isDownloaded = true;
        } else {
          bookModel.isDownloaded = false;
        }

        Get.back();
        // ignore: use_build_context_synchronously
        _showBookSheet(
          context: context,
          bookModel: bookModel,
        );
      }
    } else if (upcomingEvents[index].productName == 'sermons | video album') {
      _handleSermon(
          sermonId: upcomingEvents[index].productId!, context: context);
    }
  }

  Future<BookModel?> _fetchBook(bookId) async {
    var response =
        await BookStoreRepository.instance.fetchBookById(bookId: bookId);
    // log(response.data.toString());
    if (response.message == ApiMessage.success) {
      return response.data;
    }

    return null;
  }

  Future<SermonModel?> _fetchSermon(int id) async {
    var response = await SermonRepository.instance.fetchSermonById(id: id);

    if (response.message == ApiMessage.success) {
      return response.data;
    }

    return null;
  }

  Future<AlbumModel?> _fetchAlbum(int id) async {
    var response = await AlbumRepository.instance.fetchAlbumById(id: id);

    if (response.message == ApiMessage.success) {
      return response.data;
    }

    return null;
  }

  void _showBookSheet({
    required BuildContext context,
    required BookModel bookModel,
  }) {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxHeight: Get.width * 1.8,
        minHeight: Get.width * 1.8,
      ),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return BookPaymentBottomSheet(
          book: bookModel,
          onPressedDownload: () {
            _downloadService.addFileToDownloadingQueue(
              id: bookModel.id,
              fileType: FileType.book,
              url: bookModel.book!,
              fileName: bookModel.bookTitle,
              onDownloadCompleted: () {
                Get.find<HomeController>().refreshDownloads();
              },
            );
            Get.back();
          },
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void _handleAlbum({required context, required int albumId}) async {
    AlbumModel? albumModel = await _fetchAlbum(albumId);
    Get.back();
    if (albumModel != null &&
        ((albumModel.paymentType == 'PAID' &&
                albumModel.paymentStatus == 'P') ||
            albumModel.paymentType == 'FREE')) {
      Get.toNamed(
        albumViewScreenRoute,
        arguments: albumModel,
      );
    } else if (albumModel != null &&
        albumModel.paymentType == 'PAID' &&
        albumModel.paymentStatus == 'N') {
      // ignore: use_build_context_synchronously
      _showAlbumSheet(
        context: context,
        albumModel: albumModel,
      );
    }
  }

  void _showAlbumSheet({
    required BuildContext context,
    required AlbumModel albumModel,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AlbumPaymentBottomSheet(
          album: albumModel,
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: Get.width * 1.9,
        minHeight: Get.width * 1.9,
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  void _handleSermon({
    required int sermonId,
    required BuildContext context,
  }) async {
    SermonModel? sermonModel = await _fetchSermon(sermonId);

    Get.back();
    if (sermonModel != null &&
        ((sermonModel.paymentType == 'PAID' && sermonModel.isPurchased) ||
            sermonModel.paymentType == 'FREE')) {
      Get.toNamed(
        sermonViewScreenRoute,
        arguments: sermonModel,
      );
    } else if (sermonModel != null &&
        sermonModel.paymentType == 'PAID' &&
        !sermonModel.isPurchased) {
      // ignore: use_build_context_synchronously
      _showSermonSheet(
        context: context,
        sermonModel: sermonModel,
      );
    }
  }

  void _showSermonSheet({
    required BuildContext context,
    required SermonModel sermonModel,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SermonPaymentBottomSheet(
          sermonModel: sermonModel,
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: Get.width * 1.9,
        minHeight: Get.width * 1.9,
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }
}
