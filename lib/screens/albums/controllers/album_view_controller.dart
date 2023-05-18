import 'dart:developer';

import 'package:bookcenter/models/download_model.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/service/audio_service.dart';
import 'package:bookcenter/service/download_service.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlbumViewController extends GetxController {
  late final AlbumModel currentAlbum;
  final audioPlayerService = Get.find<AudioPlayerService>();

  final _downloadService = Get.find<DownloadService>();

  final downloadingSongsData = <int, DownloadingModel>{}.obs;

  var songs = <Song>[].obs;

  @override
  void onInit() {
    currentAlbum = Get.arguments as AlbumModel;
    songs.value = currentAlbum.songs;

    listenToDownloadingQueue();

    super.onInit();
  }

  void downloadSong({
    required String songName,
    required String songUrl,
    required int id,
  }) async {
    _downloadService.addFileToDownloadingQueue(
      id: id,
      fileType: FileType.album,
      url: songUrl,
      fileName: songName,
      albumOrSermonAuthor: currentAlbum.artist,
      albumOrSermonImage: currentAlbum.albumLogo,
      albumOrSermonName: currentAlbum.albumTitle,
      albumOrSermonId: currentAlbum.id,
      onDownloadCompleted: () {
        for (var element in currentAlbum.songs) {
          if (element.id == id) {
            element.isDownloaded = true;
          }
        }
        songs.value = currentAlbum.songs;
        songs.refresh();
      },
    );
  }

  void navigateToAlbumPlayer({required int index, required bool fromStart}) {
    // log(currentAlbum.songs.length.toString() + ' & ' + index.toString());
    audioPlayerService.album = currentAlbum;

    // log('navigateToAlbumPlayer: $index, $fromStart');
    Get.toNamed(
      albumPlayerScreenRoute,
      arguments: {
        'songIndex': index,
        'fromStart': fromStart,
      },
    );
  }

  void listenToDownloadingQueue() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _downloadService.downloadingQueue.listenAndPump((event) {
        if (event.isEmpty) {
          downloadingSongsData.clear();
        } else {
          downloadingSongsData.clear();
          for (var element in event) {
            if (element.fileType == FileType.album) {
              downloadingSongsData[element.id] = element;
            }
          }
        }
        downloadingSongsData.refresh();
      });
    });
  }

  void deleteAlbumSong({required int index}) async {
    await _downloadService.deleteFile(
      fileId: songs[index].id,
      fileName: songs[index].songTitle!,
      fileType: FileType.album,
    );
    songs[index].isDownloaded = false;

    if (audioPlayerService.songName.value == songs[index].songTitle) {
      audioPlayerService.stop();
    }

    if (songs[index].song == null || songs[index].song!.isEmpty) {
      songs.removeAt(index);
    }

    // log(currentAlbum.songs.length.toString());

    if (songs.isEmpty) {
      Get.back();
      return;
    }

    songs.refresh();
  }
}
