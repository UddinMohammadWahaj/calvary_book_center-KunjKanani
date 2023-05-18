import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class SermonPlayerController extends GetxController {
  final List<Duration> captionOffsets = <Duration>[
    const Duration(seconds: -10),
    const Duration(seconds: -3),
    const Duration(seconds: -1, milliseconds: -500),
    const Duration(milliseconds: -250),
    Duration.zero,
    const Duration(milliseconds: 250),
    const Duration(seconds: 1, milliseconds: 500),
    const Duration(seconds: 3),
    const Duration(seconds: 10),
  ];

  final List<double> playbackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  var playbackRate = 1.0.obs;

  late VideoPlayerController videoPlayerController;
  final isLoading = true.obs,
      isPlaying = false.obs,
      isOverlayVisible = true.obs;
  var secureFileStorageService = Get.find<SecureFileStorageService>();
  late SermonModel currentSermon;
  var playingSongIndex = 0.obs;

  var videoPosition = Duration.zero.obs;

  late Timer overlayTimer, videoTimer;

  @override
  void onInit() {
    super.onInit();
    currentSermon = Get.arguments['sermon'];
    playingSongIndex.value = Get.arguments['playIndex'];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      initVideoPlayer();
    });

    overlayTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (isOverlayVisible.value) {
        isOverlayVisible.value = false;
      }
    });
  }

  void initVideoPlayer() async {
    isLoading.value = true;

    if (!currentSermon.videoSongs[playingSongIndex.value].isDownloaded!) {
      videoPlayerController = VideoPlayerController.network(
        currentSermon.videoSongs[playingSongIndex.value].song!,
      );
    } else {
      var file = await secureFileStorageService.getFile(
        fileId: currentSermon.videoSongs[playingSongIndex.value].id,
        fileType: FileType.sermons,
        fileName: currentSermon.videoSongs[playingSongIndex.value].songTitle!,
      );

      List<int> bytes = await file.readAsBytes();

      String tempPath =
          '${(await getTemporaryDirectory()).path}/${currentSermon.videoSongs[playingSongIndex.value].id}.mp4';
      File tmFile = File(tempPath);

      tmFile = await tmFile.writeAsBytes(bytes);

      videoPlayerController = VideoPlayerController.file(tmFile);
    }

    videoPlayerController.initialize().then((_) {
      isLoading.value = false;
      videoPlayerController.play();
      isPlaying.value = true;

      videoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        videoPosition.value = videoPlayerController.value.position;
        if (videoPlayerController.value.position ==
            videoPlayerController.value.duration) {
          if (playingSongIndex.value < currentSermon.videoSongs.length - 1) {
            playNextVideo();
          }
        }
      });
    });
  }

  void playOrPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      isPlaying.value = false;
    } else {
      videoPlayerController.play();
      isPlaying.value = true;
    }
  }

  void clearLocalCacheFile() async {
    if (currentSermon.videoSongs[playingSongIndex.value].isDownloaded!) {
      String tempPath =
          '${(await getTemporaryDirectory()).path}/${currentSermon.videoSongs[playingSongIndex.value].id}.mp4';
      File file = File(tempPath);

      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  void playNextVideo() {
    clearLocalCacheFile();
    if (playingSongIndex.value < currentSermon.videoSongs.length - 1) {
      playingSongIndex.value++;
    } else {
      playingSongIndex.value = 0;
    }
    initVideoPlayer();
  }

  void playPreviousVideo() {
    clearLocalCacheFile();
    if (playingSongIndex.value > 0) {
      playingSongIndex.value--;
    } else {
      playingSongIndex.value = currentSermon.videoSongs.length - 1;
    }
    initVideoPlayer();
  }

  void setPlaybackRate(double rate) {
    playbackRate.value = rate;
    videoPlayerController.setPlaybackSpeed(playbackRate.value);
  }
}
