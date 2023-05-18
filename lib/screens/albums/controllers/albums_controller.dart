import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/screens/albums/repositories/album_repository.dart';
import 'package:bookcenter/screens/bookstore/models/language_model.dart';
import 'package:bookcenter/service/audio_service.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlbumController extends GetxController {
  var currentSongIndex = 0.obs,
      songProgress = 0.obs,
      songDuration = 0.obs,
      isLoadingSong = true.obs;

  late var albums = <AlbumModel>[].obs;
  final _secureFileStorageService = Get.find<SecureFileStorageService>();

  var isLastPage = false.obs,
      isFetchingAlbum = false.obs,
      isFetchingLanguages = false.obs,
      isLastLanguagePage = false.obs;

  var currentPage = 1, currentLanguagePage = 1, selectedLanguageIndex = 0.obs;

  final ScrollController scrollController = ScrollController(),
      languageScrollController = ScrollController();

  final audioPlayerService = Get.find<AudioPlayerService>();

  var playerState = PlayerState.stopped.obs;

  List<LanguageModel> languages = [
    LanguageModel(id: 0, languageIcon: '', languageTitle: 'All Languages'),
  ];

  var isFree = true.obs;

  CancelToken? cancelToken;

  @override
  void onInit() {
    initFetchAlbums();
    initFetchLanguages();

    super.onInit();
  }

  void initFetchAlbums() {
    currentPage = 1;
    isLastPage.value = false;
    isFetchingAlbum.value = false;
    albums.value = [];
    // if (cancelToken != null) {
    //   cancelToken!.cancel();
    // }
    // cancelToken = CancelToken();

    fetchAlbums(page: currentPage);

    scrollController.addListener(() {
      var nextPageTrigger = scrollController.position.maxScrollExtent * 0.8;

      if (scrollController.position.pixels >= nextPageTrigger &&
          !isFetchingAlbum.value &&
          !isLastPage.value) {
        fetchAlbums(
          page: currentPage,
        );
      }
    });
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

  void fetchAlbums({required int page}) async {
    isFetchingAlbum.value = true;

    ApiResponse response = await AlbumRepository.instance.fetchAlbums(
      page: page,
      paymentType: isFree.value ? 'FREE' : 'PAID',
      language: selectedLanguageIndex.value == 0
          ? null
          : languages[selectedLanguageIndex.value].id,
      cancelToken: cancelToken,
    );

    if (response.message == ApiMessage.success) {
      for (AlbumModel element in response.data) {
        for (var song in element.songs) {
          if (await _secureFileStorageService.isFileExist(
            fileId: song.id,
            fileType: FileType.album,
            fileName: song.songTitle ?? '',
          )) {
            song.isDownloaded = true;
          } else {
            song.isDownloaded = false;
          }
        }
      }

      if (page == 1) {
        albums.value = response.data;
      } else {
        albums.addAll(response.data);
      }

      if (albums.length < response.dataCount!) {
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

    isFetchingAlbum.value = false;
  }

  void updateAlbumPayment({
    required int id,
    required String status,
  }) {
    for (var element in albums) {
      if (element.id == id) {
        element.paymentStatus = status;
      }
    }
  }

  void fetchLanguages() async {
    isFetchingLanguages.value = true;

    ApiResponse response = await AlbumRepository.instance.fetchLanguages(
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

      // Get.snackbar(
      //   'Error',
      //   response.message!.asString,
      // );
    }

    isFetchingLanguages.value = false;
  }
}
