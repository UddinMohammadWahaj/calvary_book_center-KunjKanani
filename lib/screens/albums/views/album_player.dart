import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/albums/controllers/album_player_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class AlbumPlayerScreen extends StatefulWidget {
  const AlbumPlayerScreen({super.key});

  @override
  State<AlbumPlayerScreen> createState() => _AlbumPlayerScreenState();
}

class _AlbumPlayerScreenState extends State<AlbumPlayerScreen> {
  late AlbumPlayerController albumPlayerController;
  @override
  void initState() {
    albumPlayerController = Get.put(AlbumPlayerController());
    if (Get.arguments['fromStart']) {
      albumPlayerController.isLoadingSong.value = true;
    } else {
      albumPlayerController.isLoadingSong.value = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (Get.arguments['fromStart']) {
        await albumPlayerController.stopPlayer();
        albumPlayerController.playSong(
          Get.arguments['songIndex'],
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  albumPlayerController.currentAlbum.value.albumLogo ??
                      "https://cdn.dribbble.com/users/1195991/screenshots/5257848/media/80aace77221081102d5fcbd9cdefda3a.jpg?compress=1&resize=1600x1200&vertical=top",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.06,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              SizedBox(
                height: Get.height * 0.3,
                width: Get.height * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    albumPlayerController.currentAlbum.value.albumLogo ??
                        "https://cdn.dribbble.com/users/1195991/screenshots/5257848/media/80aace77221081102d5fcbd9cdefda3a.jpg?compress=1&resize=1600x1200&vertical=top",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              Text(
                albumPlayerController.currentAlbum.value.albumTitle ?? '',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Text(
                albumPlayerController.currentAlbum.value.artist ?? '',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      albumPlayerController.playPreviousSong();
                    },
                    icon: const Icon(
                      CupertinoIcons.backward_fill,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                  ),
                  GetX<AlbumPlayerController>(
                    builder: (controller) {
                      // developer.log(controller.isLoadingSong.value.toString());
                      return IconButton(
                        onPressed: () {
                          controller.playOrPause();
                        },
                        icon: controller.isLoadingSong.value
                            ? const SpinKitDoubleBounce(
                                color: Colors.white,
                                size: 40,
                              )
                            : Icon(
                                controller.playerState.value ==
                                        PlayerState.playing
                                    ? CupertinoIcons.pause_fill
                                    : CupertinoIcons.play_fill,
                                color: Colors.white,
                              ),
                        iconSize: 40,
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      albumPlayerController.playNextSong();
                    },
                    icon: const Icon(
                      //Next icon
                      CupertinoIcons.forward_fill,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              GetX<AlbumPlayerController>(
                builder: (controller) {
                  return Slider(
                    value: controller.songProgress.value.toDouble(),
                    onChanged: (value) {
                      controller.seekTo(value.toInt());
                    },
                    min: 0,
                    max: controller.songDuration.value.toDouble(),
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.5),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.height * 0.03,
                ),
                child: GetX<AlbumPlayerController>(
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Duration(
                            seconds: controller.songProgress.value,
                          ).toString().substring(2, 7),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        Text(
                          Duration(
                            seconds: controller.songDuration.value,
                          ).toString().substring(2, 7),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Icons.repeat,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  if (albumPlayerController.currentAlbum.value.songs.length > 1)
                    IconButton(
                      onPressed: () {
                        albumPlayerController.playSong(
                          Random().nextInt(
                            albumPlayerController
                                .currentAlbum.value.songs.length,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.shuffle,
                        color: Colors.white,
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const MusicQueue(),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxHeight: Get.height * 0.8,
                          minHeight: Get.height * 0.8,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.queue_music,
                      color: Colors.white,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     // Share icon
                  //     Icons.share,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MusicQueue extends StatelessWidget {
  const MusicQueue({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.black.withOpacity(0.5),
      ),
      child: Stack(
        children: [
          // Burry background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(
                  top: defaultPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Up Next',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: Get.find<AlbumPlayerController>()
                      .currentAlbum
                      .value
                      .songs
                      .length,
                  itemBuilder: (context, index) {
                    return GetX<AlbumPlayerController>(
                      builder: (controller) {
                        return Container(
                          color: controller.currentSongIndex.value == index
                              ? Colors.white.withOpacity(0.1)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: ListTile(
                            onTap: () {
                              controller.playSong(index);
                            },
                            contentPadding: const EdgeInsets.all(0),
                            leading: Stack(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      controller.currentAlbum.value.albumLogo ??
                                          "https://cdn.dribbble.com/users/1195991/screenshots/5257848/media/80aace77221081102d5fcbd9cdefda3a.jpg?compress=1&resize=1600x1200&vertical=top",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                controller.currentSongIndex.value == index
                                    ? SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: SpinKitWave(
                                          size: 20,
                                          itemCount: 3,
                                          type: SpinKitWaveType.center,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            title: Text(
                              Get.find<AlbumPlayerController>()
                                      .currentAlbum
                                      .value
                                      .songs[index]
                                      .songTitle ??
                                  '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              Get.find<AlbumPlayerController>()
                                      .currentAlbum
                                      .value
                                      .artist ??
                                  '',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
