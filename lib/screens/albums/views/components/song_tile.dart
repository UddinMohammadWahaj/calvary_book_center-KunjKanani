import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/route/screen_export.dart';
import 'package:bookcenter/screens/albums/controllers/album_view_controller.dart';
import 'package:bookcenter/screens/albums/controllers/albums_controller.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SongTile extends StatelessWidget {
  final Song song;

  final int index;

  final String artiseName;

  const SongTile({
    super.key,
    required this.song,
    required this.index,
    required this.artiseName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            // Get.toNamed(youtubePlayerScreenRoute, arguments: song.youtubeLink);

            Get.find<AlbumViewController>().navigateToAlbumPlayer(
              index: index,
              fromStart: true,
            );
          },
          title: Row(
            children: [
              // CachedNetworkImage(
              //   imageUrl:
              //       "https://cdn.dribbble.com/users/1195991/screenshots/5257848/media/80aace77221081102d5fcbd9cdefda3a.jpg?compress=1&resize=1600x1200&vertical=top",
              //   fit: BoxFit.cover,
              //   width: 50,
              //   height: 50,
              // ),
              const Icon(
                CupertinoIcons.music_note_2,
                color: primaryColor,
                size: 28,
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      song.songTitle ?? '',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: defaultPadding / 4,
                    ),
                    Text(
                      '$artiseName ${song.isDownloaded! ? '• Downloaded' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // if (!song.isDownloaded!)
              GetX<AlbumViewController>(
                builder: (controller) {
                  return !controller.songs[index].isDownloaded!
                      ? GestureDetector(
                          onTap: () {
                            controller.downloadSong(
                              id: song.id,
                              songUrl: song.song ?? '',
                              songName: song.songTitle ?? '',
                            );
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: defaultPadding / 2,
                              ),
                              controller.downloadingSongsData
                                      .containsKey(song.id)
                                  ? SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: Stack(
                                        children: [
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                            backgroundColor: Colors.grey,
                                            value: controller
                                                .downloadingSongsData[song.id]!
                                                .downloadProgress,
                                          ),
                                          Center(
                                            child: Text(
                                              "${(controller.downloadingSongsData[song.id]!.downloadProgress * 100).toStringAsFixed(0)}%",
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Icon(
                                      CupertinoIcons.cloud_download,
                                      color: primaryColor,
                                      size: 28,
                                    ),
                              const SizedBox(
                                width: defaultPadding / 2,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                },
              ),
              if (song.isDownloaded ?? false)
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    Get.find<AlbumViewController>().deleteAlbumSong(
                      index: index,
                    );
                  },
                ),
            ],
          ),
        ),
        const Divider(
          height: 0,
          thickness: 1,
        ),
      ],
    );
  }
}
