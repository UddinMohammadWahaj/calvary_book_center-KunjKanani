import 'dart:typed_data';

import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CalvaryPdfViewerController extends GetxController {
  final PdfViewerController pdfViewerController = PdfViewerController();
  PdfTextSearchResult? result;
  var pageCount = 1.0.obs, currentPageNumber = 1.0.obs;
  final TextEditingController searchController = TextEditingController();

  var isFetchingBook = false.obs,
      isSearching = false.obs,
      isSearchDialogOpen = false.obs,
      searchToggle = false.obs;

  var bookId = 0.obs;

  late final BookModel currentBook;

  late Uint8List downloadedBookData;

  @override
  void onInit() {
    if (Get.arguments['book'] != null) {
      currentBook = Get.arguments['book'];

      if (currentBook.isDownloaded) {
        fetchBookDataFromLocal();
      }
    }

    super.onInit();
  }

  void search() {
    if (searchController.text.isEmpty) {
      if (result != null) result!.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    result = pdfViewerController.searchText(
      searchController.text,
    );

    result!.addListener(() {
      searchToggle.value = !searchToggle.value;
    });
  }

  void clearSearch() {
    searchController.clear();
    isSearching.value = false;
    if (result != null) result!.clear();
    isSearchDialogOpen.value = false;
  }

  void toggleSearch() {
    isSearchDialogOpen.value = !isSearchDialogOpen.value;
  }

  void fetchBookDataFromLocal() async {
    isFetchingBook.value = true;
    var file = await Get.find<SecureFileStorageService>().getFile(
      fileName: currentBook.bookTitle,
      fileId: currentBook.id,
      fileType: FileType.book,
    );

    List<int> bytes = file.readAsBytesSync();

    downloadedBookData = Uint8List.fromList(bytes);
    isFetchingBook.value = false;
  }
}
