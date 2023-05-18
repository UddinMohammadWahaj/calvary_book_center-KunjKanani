import 'package:bookcenter/models/download_model.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/service/download_service.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SermonViewController extends GetxController {
  late final SermonModel currentSermon;
  var videoSongs = <VideoSong>[].obs;

  final downloadingVideoSongsData = <int, DownloadingModel>{}.obs;
  final _downloadService = Get.find<DownloadService>();

  @override
  void onInit() {
    if (Get.arguments != null) {
      currentSermon = Get.arguments as SermonModel;
      videoSongs.value = currentSermon.videoSongs;
      listenToDownloadingQueue();
    }
    super.onInit();
  }

  void downloadVideoSong({
    required String videoSongName,
    required String videoSongUrl,
    required int id,
  }) async {
    _downloadService.addFileToDownloadingQueue(
      id: id,
      fileType: FileType.sermons,
      url: videoSongUrl,
      albumOrSermonAuthor: currentSermon.sermonsArtist,
      albumOrSermonId: currentSermon.id,
      albumOrSermonImage: currentSermon.sermonsLogo,
      albumOrSermonName: currentSermon.sermonsTitle,
      fileName: videoSongName,
      onDownloadCompleted: () {
        for (var element in videoSongs) {
          if (element.id == id) {
            element.isDownloaded = true;
          }
        }
        videoSongs.value = currentSermon.videoSongs;
        videoSongs.refresh();
      },
    );
  }

  void navigateToSermonPlayer({required int index}) async {
    var videoLink = videoSongs[index].youtubeLink ?? videoSongs[index].song;

    if (videoSongs[index].youtubeLink != null) {
      Get.toNamed(youtubePlayerScreenRoute, arguments: {
        'initialVideoId': initialYoutubeIdFromLinnk(videoLink!),
      });
    } else {
      Get.toNamed(
        videoPlayerScreenRoute,
        arguments: {
          'sermon': currentSermon,
          'playIndex': index,
        },
      );
    }
  }

  initialYoutubeIdFromLinnk(String link) {
    var youtubeId = YoutubePlayerController.convertUrlToId(link);
    return youtubeId;
  }

  void listenToDownloadingQueue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _downloadService.downloadingQueue.listenAndPump((event) {
        if (event.isEmpty) {
          downloadingVideoSongsData.clear();
        } else {
          downloadingVideoSongsData.clear();
          for (var element in event) {
            if (element.fileType == FileType.sermons) {
              downloadingVideoSongsData[element.id] = element;
            }
          }
        }
        downloadingVideoSongsData.refresh();
      });
    });
  }

  void deleteSermonSong({required int index}) async {
    await _downloadService.deleteFile(
      fileId: videoSongs[index].id,
      fileName: videoSongs[index].songTitle!,
      fileType: FileType.sermons,
    );
    videoSongs[index].isDownloaded = false;

    if (videoSongs[index].song == null || videoSongs[index].song!.isEmpty) {
      videoSongs.removeAt(index);
    }

    if (videoSongs.isEmpty) {
      Get.back();
      return;
    }

    videoSongs.refresh();
  }
}
