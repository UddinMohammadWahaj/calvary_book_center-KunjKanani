import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/screens/albums/repositories/album_repository.dart';
import 'package:bookcenter/screens/bookstore/repositories/book_store_reposotory.dart';
import 'package:bookcenter/screens/home/controllers/home_controller.dart';
import 'package:bookcenter/screens/search/models/search_model.dart';
import 'package:bookcenter/screens/search/repositories/search_repository.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/screens/sermons/repositories/sermon_repository.dart';
import 'package:bookcenter/service/audio_service.dart';
import 'package:bookcenter/service/download_service.dart';
import 'package:bookcenter/service/service_elements/album_payment_bottom_sheet.dart';
import 'package:bookcenter/service/service_elements/book_payment_bottom_sheet.dart';
import 'package:bookcenter/service/service_elements/sermon_payment_bottom_sheet.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final isSearching = false.obs, isFocused = false.obs;

  final searchResults = <SearchModel>[].obs;

  final ScrollController scrollController = ScrollController();

  var currentPage = 1;
  var isLastPage = false, isFetchingData = false.obs;

  final secureFileStorageService = Get.find<SecureFileStorageService>();
  final _downloadService = Get.find<DownloadService>();
  final audioPlayerService = Get.find<AudioPlayerService>();

  void initSearch(String query) {
    currentPage = 1;
    isLastPage = false;
    searchResults.clear();
    searchResults.refresh();

    search(
      page: currentPage,
      query: query,
    );

    scrollController.addListener(() {
      var nextPageTrigger = scrollController.position.maxScrollExtent * 0.8;

      if (scrollController.position.pixels >= nextPageTrigger &&
          !isSearching.value &&
          !isLastPage) {
        search(
          page: currentPage,
          query: query,
        );
      }
    });
  }

  Future search({
    required String query,
    required int page,
  }) async {
    isSearching.value = true;

    var response =
        await SearchRepository.instance.search(query: query, page: page);

    if (response.message == ApiMessage.success) {
      if (page == 1) {
        searchResults.value = response.data;
      } else {
        searchResults.addAll(response.data);
      }

      if (searchResults.length < response.dataCount!) {
        currentPage++;
      } else {
        isLastPage = true;
      }
    } else {
      // log(response.data.toString());
    }

    isSearching.value = false;
  }

  void navigateToPage({
    required int id,
    required int parentId,
    required String type,
    required String value,
    required BuildContext context,
  }) async {
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
    if (type == 'book') {
      BookModel? bookModel = await _fetchBook(id);

      if (bookModel != null) {
        var fileExists = await secureFileStorageService.isFileExist(
          fileId: id,
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
    } else if (type == 'album') {
      // ignore: use_build_context_synchronously
      _handleAlbum(albumId: id, context: context);
    } else if (type == 'song' && parentId != 0) {
      // ignore: use_build_context_synchronously
      _handleAlbum(albumId: parentId, context: context);
    } else if (type == 'sermon') {
      _handleSermon(sermonId: id, context: context);
    } else if (type == 'sermon_song' && parentId != 0) {
      _handleSermon(sermonId: parentId, context: context);
    } else if (type == 'product') {
      Get.back();
      Get.toNamed(
        productDetailsScreenRoute,
        arguments: {'productId': id},
      );
    }
  }

  Future<BookModel?> _fetchBook(bookId) async {
    isFetchingData.value = true;

    var response =
        await BookStoreRepository.instance.fetchBookById(bookId: bookId);

    if (response.message == ApiMessage.success) {
      return response.data;
    }

    isFetchingData.value = false;
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

  Future<AlbumModel?> _fetchAlbum(int id) async {
    var response = await AlbumRepository.instance.fetchAlbumById(id: id);

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
}
