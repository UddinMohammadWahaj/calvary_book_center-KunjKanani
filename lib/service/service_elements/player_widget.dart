import 'package:audioplayers/audioplayers.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicPlayerTile extends StatefulWidget {
  const MusicPlayerTile({super.key});

  @override
  State<MusicPlayerTile> createState() => _MusicPlayerTileState();
}

class _MusicPlayerTileState extends State<MusicPlayerTile>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> rotationAnimation;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );

    animationController.forward();

    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<AudioPlayerService>(
      builder: (audioPlayerService) {
        if (audioPlayerService.playerState.value == PlayerState.playing) {
          animationController.forward();
        } else {
          animationController.stop();
        }

        return audioPlayerService.playerState.value == PlayerState.stopped
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  Get.toNamed(
                    albumPlayerScreenRoute,
                    arguments: {
                      'songIndex': audioPlayerService.playingIndex,
                      'fromStart': false,
                    },
                  );
                },
                child: Container(
                  color: primaryColor,
                  height: 80,
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: rotationAnimation.value,
                            child: CircleAvatar(
                              radius: 30,
                              // backgroundColor: Colors.red,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://img.icons8.com/emoji/96/null/optical-disc.png",
                                fit: BoxFit.cover,
                              ),
                              // foregroundColor: Colors.red,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              audioPlayerService.songName.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              audioPlayerService.artistName.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          audioPlayerService.playOrPause();
                        },
                        icon: Icon(
                          audioPlayerService.playerState.value ==
                                  PlayerState.playing
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          audioPlayerService.stop();
                        },
                        icon: const Icon(
                          Icons.stop,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
