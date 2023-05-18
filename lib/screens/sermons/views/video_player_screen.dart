import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/sermons/controllers/sermon_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(SermonPlayerController());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GetX<SermonPlayerController>(
          builder: (controller) {
            return controller.isLoading.value
                ? const CircularProgressIndicator()
                : Stack(
                    children: [
                      VideoPlayer(
                        Get.find<SermonPlayerController>()
                            .videoPlayerController,
                      ),
                      _buildControlsOverlay(),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Get.find<SermonPlayerController>().isOverlayVisible.value =
                !Get.find<SermonPlayerController>().isOverlayVisible.value;
          },
        ),
        GestureDetector(
          onTap: () {
            Get.find<SermonPlayerController>().isOverlayVisible.value =
                !Get.find<SermonPlayerController>().isOverlayVisible.value;
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: GetX<SermonPlayerController>(
              builder: (controller) {
                return !controller.isOverlayVisible.value
                    ? const SizedBox.shrink()
                    : Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding * 4,
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                VideoProgressIndicator(
                                  Get.find<SermonPlayerController>()
                                      .videoPlayerController,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                    playedColor: primaryColor,
                                    bufferedColor:
                                        Colors.white.withOpacity(0.5),
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    GetX<SermonPlayerController>(
                                        builder: (controller) {
                                      return Text(
                                        controller.videoPosition.value
                                            .toString()
                                            .split('.')
                                            .first,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                    const Spacer(),
                                    Text(
                                      Get.find<SermonPlayerController>()
                                          .videoPlayerController
                                          .value
                                          .duration
                                          .toString()
                                          .split('.')
                                          .first,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.skip_previous,
                                        color: Colors.white,
                                        size: 38.0,
                                      ),
                                      onPressed: () {
                                        Get.find<SermonPlayerController>()
                                            .playPreviousVideo();
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      icon: GetX<SermonPlayerController>(
                                        builder: (controller) {
                                          return controller.isPlaying.value
                                              ? const Icon(
                                                  Icons.pause,
                                                  color: Colors.white,
                                                  size: 38.0,
                                                )
                                              : const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 38.0,
                                                );
                                        },
                                      ),
                                      onPressed: () {
                                        Get.find<SermonPlayerController>()
                                            .playOrPause();
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.skip_next,
                                        color: Colors.white,
                                        size: 38.0,
                                      ),
                                      onPressed: () {
                                        Get.find<SermonPlayerController>()
                                            .playNextVideo();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GetX<SermonPlayerController>(
            builder: (controller) {
              return PopupMenuButton<double>(
                initialValue: controller.playbackRate.value,
                tooltip: 'Playback speed',
                onSelected: (double speed) {
                  Get.find<SermonPlayerController>().setPlaybackRate(speed);
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<double>>[
                    for (final double speed
                        in Get.find<SermonPlayerController>().playbackRates)
                      PopupMenuItem<double>(
                        value: speed,
                        child: Text('${speed}x'),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Text(
                    '${Get.find<SermonPlayerController>().videoPlayerController.value.playbackSpeed} x',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Get.find<SermonPlayerController>().clearLocalCacheFile();
    Get.find<SermonPlayerController>().videoPlayerController.dispose();
    Get.find<SermonPlayerController>().videoTimer.cancel();
    Get.find<SermonPlayerController>().overlayTimer.cancel();

    super.dispose();
  }
}
