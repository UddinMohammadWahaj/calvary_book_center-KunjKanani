import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/bookstore/models/language_model.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/screens/sermons/repositories/sermon_repository.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SermonController extends GetxController {
  var currentSongIndex = 0.obs;

  var songProgress = 0.obs, songDuration = 0.obs;

  late var sermons = <SermonModel>[];
  final _secureFileStorageService = Get.find<SecureFileStorageService>();

  var isLastPage = false.obs,
      isFetchingSermon = false.obs,
      isFetchingLanguages = false.obs,
      isLastLanguagePage = false.obs;
  var currentPage = 1, currentLanguagePage = 1, selectedLanguageIndex = 0.obs;

  final ScrollController scrollController = ScrollController(),
      languageScrollController = ScrollController();

  var isFree = true.obs;

  List<LanguageModel> languages = [
    LanguageModel(id: 0, languageIcon: '', languageTitle: 'All Languages'),
  ];

  @override
  void onInit() {
    initFetchSermons();
    initFetchLanguages();
    super.onInit();
  }

  void initFetchSermons() {
    currentPage = 1;
    isLastPage.value = false;
    isFetchingSermon.value = false;
    sermons = [];

    fetchSermons(page: currentPage);

    scrollController.addListener(() {
      var nextPageTrigger = scrollController.position.maxScrollExtent * 0.8;

      if (scrollController.position.pixels >= nextPageTrigger &&
          !isFetchingSermon.value &&
          !isLastPage.value) {
        fetchSermons(
          page: currentPage,
        );
      }
    });
  }

  void fetchSermons({required int page}) async {
    isFetchingSermon.value = true;

    ApiResponse response = await SermonRepository.instance.fetchSermons(
      page: page,
      paymentType: isFree.value ? 'FREE' : 'PAID',
      language: selectedLanguageIndex.value == 0
          ? null
          : languages[selectedLanguageIndex.value].id,
    );

    if (response.message == ApiMessage.success) {
      for (SermonModel element in response.data) {
        for (var videoSong in element.videoSongs) {
          if (await _secureFileStorageService.isFileExist(
            fileId: videoSong.id,
            fileType: FileType.sermons,
            fileName: videoSong.songTitle ?? '',
          )) {
            videoSong.isDownloaded = true;
          } else {
            videoSong.isDownloaded = false;
          }
        }
      }

      if (page == 1) {
        sermons = response.data;
      } else {
        sermons.addAll(response.data);
      }

      if (sermons.length < response.dataCount!) {
        currentPage++;
      } else {
        isLastPage.value = true;
      }
    } else {
      // log(response.data.toString());
      // Get.snackbar(
      //   'Error',
      //   response.data.toString(),
      // );
    }

    isFetchingSermon.value = false;
  }

  void initFetchLanguages() {
    currentLanguagePage = 1;
    isLastLanguagePage.value = false;
    isFetchingLanguages.value = false;
    languages = [
      LanguageModel(id: 0, languageIcon: '', languageTitle: 'All Languages'),
    ];

    fetchLanguages();

    languageScrollController.addListener(() {
      var nextPageTrigger =
          languageScrollController.position.maxScrollExtent * 0.8;

      if (languageScrollController.position.pixels >= nextPageTrigger &&
          !isFetchingLanguages.value &&
          !isLastLanguagePage.value) {
        fetchLanguages();
      }
    });
  }

  void updateSermonPayment({
    required int id,
    required String status,
  }) {
    for (var element in sermons) {
      if (element.id == id) {
        element.paymentStatus = status;
      }
    }
  }

  void fetchLanguages() async {
    isFetchingLanguages.value = true;

    ApiResponse response = await SermonRepository.instance.fetchLanguages(
      page: currentLanguagePage,
    );

    if (response.message == ApiMessage.success) {
      languages.addAll(response.data);

      if (languages.length < response.dataCount!) {
        currentLanguagePage++;
      } else {
        isLastLanguagePage.value = true;
      }
    } else {
      // log(response.message!.asString);
      Get.snackbar(
        'Error',
        response.message!.asString,
      );
    }

    isFetchingLanguages.value = false;
  }
}
