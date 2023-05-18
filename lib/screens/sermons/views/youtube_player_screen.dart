import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({super.key});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // log(
    //   Get.arguments['initialVideoId'],
    // );
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Youtube Player"),
      // ),
      body: YoutubePlayer(
        controller: YoutubePlayerController.fromVideoId(
          videoId: Get.arguments['initialVideoId'],
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
          ),
          autoPlay: true,
        ),
        // Aspect ratio of the video player in landscape mode.
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
