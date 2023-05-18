import 'dart:convert';

import 'package:bookcenter/models/book_model.dart';
import 'package:bookcenter/route/route_constants.dart';
import 'package:bookcenter/screens/albums/models/album_model.dart';
import 'package:bookcenter/screens/sermons/models/sermon_model.dart';
import 'package:bookcenter/service/download_service.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:get/get.dart';

class DownloadController extends GetxController {
  final _downloadService = Get.find<DownloadService>();
  final downloadedFiles = <String, dynamic>{}.obs;
  final downloadedSermons = <SermonModel>[].obs;
  final downloadedBooks = <BookModel>[].obs;
  final downloadedAlbums = <AlbumModel>[].obs;

  @override
  void onInit() {
    _listenDownloads();
    super.onInit();
  }

  void _listenDownloads() async {
    _downloadService.downloadedFiles.listenAndPump(
      (Map<String, dynamic> fileDatas) {
        downloadedFiles.value = fileDatas;

        downloadedSermons.clear();
        downloadedAlbums.clear();
        downloadedBooks.clear();

        fileDatas.forEach((key, value) {
          value = jsonDecode(value ?? '');

          if (value['type'] == 'sermons') {
            var isSermonExist = false;

            for (var element in downloadedSermons) {
              if (element.id == value['parentId']) {
                isSermonExist = true;

                element.videoSongs.add(
                  VideoSong(
                    id: value['fileId'],
                    songTitle: value['fileName'],
                    isDownloaded: true,
                  ),
                );

                break;
              }
            }

            if (!isSermonExist) {
              downloadedSermons.add(
                SermonModel(
                  id: value['parentId'],
                  sermonsTitle: value['parentTitle'],
                  sermonsLogo: value['parentImage'],
                  videoSongs: [
                    VideoSong(
                      id: value['fileId'],
                      songTitle: value['fileName'],
                      isDownloaded: true,
                    ),
                  ],
                ),
              );
            }
          } else if (value['type'] == 'book') {
            downloadedBooks.add(
              BookModel(
                id: value['fileId'],
                bookTitle: value['fileName'],
                isDownloaded: true,
              ),
            );
          } else if (value['type'] == 'album') {
            var isAlbumExist = false;
            for (var element in downloadedAlbums) {
              if (element.id == value['parentId']) {
                isAlbumExist = true;
                element.songs.add(
                  Song(
                    id: value['fileId'],
                    songTitle: value['fileName'],
                    isDownloaded: true,
                  ),
                );
                break;
              }
            }

            if (!isAlbumExist) {
              downloadedAlbums.add(
                AlbumModel(
                  id: value['parentId'],
                  albumTitle: value['parentTitle'],
                  artist: value['parentAuthor'],
                  albumLogo: value['parentImage'],
                  songs: [
                    Song(
                      id: value['fileId'],
                      songTitle: value['fileName'],
                      isDownloaded: true,
                    ),
                  ],
                ),
              );
            }
          }
        });
      },
    );
  }

  void navigateToSermonViewer({required int index}) {
    Get.toNamed(
      sermonViewScreenRoute,
      arguments: downloadedSermons[index],
    );
  }

  void navigateToAlbumViewer({required int index}) {
    Get.toNamed(
      albumViewScreenRoute,
      arguments: downloadedAlbums[index],
    );
  }

  void navigateToCalvaryPdfViewer({required int index}) {
    Get.toNamed(
      calvaryPdfViewerScreenRoute,
      arguments: {
        'book': downloadedBooks[index],
      },
    );
  }

  void deleteDownloadedBook({required int index}) {
    _downloadService.deleteFile(
      fileId: downloadedBooks[index].id,
      fileName: downloadedBooks[index].bookTitle,
      fileType: FileType.book,
    );

    downloadedBooks.removeAt(index);
  }
}
