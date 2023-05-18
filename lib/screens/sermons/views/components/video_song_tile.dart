import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/sermons/controllers/sermon_view_controller.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoSongTile extends StatelessWidget {
  final VideoSong videoSong;

  final int index;

  final String artiseName;

  const VideoSongTile({
    super.key,
    required this.videoSong,
    required this.index,
    required this.artiseName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.find<SermonViewController>().navigateToSermonPlayer(
              index: index,
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
                CupertinoIcons.video_camera_solid,
                size: 28,
                color: primaryColor,
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
                      videoSong.songTitle ?? '',
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
                      '$artiseName ${videoSong.isDownloaded! ? '• Downloaded' : ''}',
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
              GetX<SermonViewController>(
                builder: (controller) {
                  return !controller.videoSongs[index].isDownloaded!
                      ? Visibility(
                          visible:
                              controller.videoSongs[index].youtubeLink == null,
                          child: GestureDetector(
                            onTap: () {
                              controller.downloadVideoSong(
                                id: videoSong.id,
                                videoSongUrl: videoSong.song ?? '',
                                videoSongName: videoSong.songTitle ?? '',
                              );
                            },
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                controller.downloadingVideoSongsData
                                        .containsKey(videoSong.id)
                                    ? SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Stack(
                                          children: [
                                            CircularProgressIndicator(
                                              strokeWidth: 2,
                                              backgroundColor: Colors.grey,
                                              value: controller
                                                  .downloadingVideoSongsData[
                                                      videoSong.id]!
                                                  .downloadProgress,
                                            ),
                                            Center(
                                              child: Text(
                                                "${(controller.downloadingVideoSongsData[videoSong.id]!.downloadProgress * 100).toStringAsFixed(0)}%",
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
                          ),
                        )
                      : const SizedBox();
                },
              ),
              if (videoSong.isDownloaded ?? false)
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    Get.find<SermonViewController>().deleteSermonSong(
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
