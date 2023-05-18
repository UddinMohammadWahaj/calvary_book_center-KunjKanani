import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/models/download_model.dart';
import 'package:bookcenter/screens/bookstore/models/language_model.dart';
import 'package:bookcenter/screens/bookstore/repositories/book_store_reposotory.dart';
import 'package:bookcenter/screens/home/controllers/home_controller.dart';
import 'package:bookcenter/service/download_service.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class BookListController extends GetxController {
  ScrollController scrollController = ScrollController();
  ScrollController languageScrollController = ScrollController();
  int? bookCategoryId;
  var selectedLanguageIndex = 0.obs;
  int currentPage = 1, currentLanguagePage = 1;
  var isFetchingBooks = false.obs, isFetchingLanguages = false.obs;

  bool isLastPage = false, isLastLanguagePage = false;
  List<BookModel> books = [];
  String bookCategoryName = '', languageName = '';
  List<LanguageModel> languages = [
    LanguageModel(id: 0, languageIcon: '', languageTitle: 'All Languages'),
  ];

  final storage = const FlutterSecureStorage();
  final secureFileStorageService = Get.find<SecureFileStorageService>();

  final downloadingBooksData = <int, DownloadingModel>{}.obs;
  final _downloadService = Get.find<DownloadService>();

  var isFree = true.obs;

  @override
  void onInit() {
    // log(Get.arguments.toString());
    bookCategoryId = Get.arguments['id'];
    bookCategoryName = Get.arguments['name'];
    initFetchBooks();
    initFetchLanguages();

    listenToDownloadingQueue();

    super.onInit();
  }

  void initFetchBooks() {
    resetBooks();

    fetchBooks(
      page: currentPage,
    );

    scrollController.addListener(() {
      if (isFetchingBooks.value || isLastPage) {
        return;
      }

      var nextTriggeredPage = scrollController.position.maxScrollExtent * 0.8;

      if (scrollController.position.pixels >= nextTriggeredPage) {
        fetchBooks(page: currentPage);
      }
    });
  }

  void fetchBooks({required int page}) async {
    isFetchingBooks.value = true;
    final response = await BookStoreRepository.instance.fetchBooksBySubCategory(
      category: bookCategoryId,
      page: page,
      language: selectedLanguageIndex.value == 0
          ? null
          : languages[selectedLanguageIndex.value].id,
      paymentType: isFree.value ? 'free' : 'paid',
    );
    if (response.message == ApiMessage.success) {
      for (BookModel element in response.data) {
        if (await isFileExistLocally(element.id, element.bookTitle)) {
          element.isDownloaded = true;
        } else {
          element.isDownloaded = false;
        }
      }

      if (page == 1) {
        books = response.data;
      } else {
        books.addAll(response.data);
      }

      if (books.length < response.dataCount!) {
        currentPage++;
      } else {
        isLastPage = true;
      }
    }

    isFetchingBooks.value = false;
  }

  void initFetchLanguages() {
    fetchLanguages(
      page: currentLanguagePage,
    );

    languageScrollController.addListener(() {
      if (isFetchingLanguages.value || isLastLanguagePage) {
        return;
      }

      var nextTriggeredPage =
          languageScrollController.position.maxScrollExtent * 0.8;

      if (languageScrollController.position.pixels >= nextTriggeredPage) {
        fetchLanguages(page: currentLanguagePage);
      }
    });
  }

  void fetchLanguages({required int page}) async {
    isFetchingLanguages.value = true;
    final response = await BookStoreRepository.instance.fetchLanguages(
      page: page,
    );

    if (response.message == ApiMessage.success) {
      if (page == 1) {
        languages.addAll(response.data);
      } else {
        languages.addAll(response.data);
      }

      if (languages.length < response.dataCount!) {
        currentLanguagePage++;
      } else {
        isLastLanguagePage = true;
      }
    }
    isFetchingLanguages.value = false;
  }

  void resetBooks() {
    books = [];
    currentPage = 1;
    isLastPage = false;
    scrollController.dispose();
    scrollController = ScrollController();
  }

  void resetLanguages() {
    languages = [
      LanguageModel(id: 0, languageIcon: '', languageTitle: 'All Languages'),
    ];
    currentLanguagePage = 1;
    isLastLanguagePage = false;
    languageScrollController.dispose();
    languageScrollController = ScrollController();
  }

  void downloadBook({
    required int bookId,
    required String bookUrl,
    required String bookName,
  }) async {
    _downloadService.addFileToDownloadingQueue(
      id: bookId,
      fileType: FileType.book,
      url: bookUrl,
      fileName: bookName,
      onDownloadCompleted: () {
        for (var element in books) {
          if (element.id == bookId) {
            element.isDownloaded = true;
          }
        }

        Get.find<HomeController>().refreshDownloads();
      },
    );
  }

  Future<bool> isFileExistLocally(int fileId, String fileName) async {
    return await secureFileStorageService.isFileExist(
      fileId: fileId,
      fileType: FileType.book,
      fileName: fileName,
    );
  }

  void updateBookPayment({
    required int id,
    required String status,
  }) {
    for (var element in books) {
      if (element.id == id) {
        element.paymentStatus = status;
      }
    }
  }

  void listenToDownloadingQueue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });
  }
}
