import 'dart:developer';

import 'package:bookcenter/constants.dart';
import 'package:bookcenter/models/download_model.dart';
import 'package:bookcenter/service/api_services/api_service.dart';
import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadService extends GetxService {
  final _apiService = Get.find<ApiService>();
  final _secureFileStorageService = Get.find<SecureFileStorageService>();

  final RxList<DownloadingModel> downloadingQueue = <DownloadingModel>[].obs;

  final RxMap<String, dynamic> downloadedFiles = <String, dynamic>{}.obs;

  bool _isDownloading = false;

  @override
  void onInit() {
    downloadingQueue.listen(
      (event) async {
        if (_isDownloading || event.isEmpty) return;

        var element = event.first;

        if (element.downloadStatus == DownloadStatus.pending) {
          // log('Downloading: ${element.id}');

          _isDownloading = true;
          element.downloadStatus = DownloadStatus.downloading;
          ApiResponse apiResponse = await downloadFile(
            url: element.url,
            onReceiveProgress: element.onReceiveProgress,
          );

          if (apiResponse.message == ApiMessage.success) {
            await _storeFileInSecureStorage(
              fileType: element.fileType,
              fileName: element.fileName,
              data: apiResponse.data,
              fileId: element.id,
              albumOrSermonName: element.parentName,
              albumOrSermonImage: element.parentImage,
              albumOrSermonAuthor: element.parentAuthor,
              albumOrSermonId: element.parentId,
            );
            element.onDownloadCompleted?.call();

            element.downloadProgress = 1;

            element.downloadStatus = DownloadStatus.completed;
          } else {
            element.downloadStatus = DownloadStatus.failed;

            Get.snackbar(
              'Download Failed',
              'Please try again later',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }

          element.downloadProgress = 0;
          downloadingQueue.removeAt(0);
          _isDownloading = false;

          // log('Downloaded: ${element.id}');

          if (downloadingQueue.isNotEmpty) {
            downloadingQueue.refresh();
          }

          _getAllDownloadedFiles();
        }
      },
    );

    _getAllDownloadedFiles();

    super.onInit();
  }

  // Add to Queue
  void addFileToDownloadingQueue({
    required int id,
    required FileType fileType,
    required String url,
    required String fileName,
    VoidCallback? onDownloadCompleted,
    String? albumOrSermonName,
    String? albumOrSermonImage,
    String? albumOrSermonAuthor,
    int? albumOrSermonId,
  }) {
    downloadingQueue.add(
      DownloadingModel(
        id: id,
        fileType: fileType,
        url: url,
        fileName: fileName,
        parentName: albumOrSermonName ?? '',
        parentImage: albumOrSermonImage ?? '',
        parentAuthor: albumOrSermonAuthor ?? '',
        parentId: albumOrSermonId ?? 0,
        onReceiveProgress: (int received, int total) {
          if (total != -1) {
            for (var element in downloadingQueue) {
              if (element.id == id) {
                var percent = received / total;

                if (percent < 0.98) {
                  element.downloadProgress = percent;
                  downloadingQueue.refresh();
                }
              }
            }
          }
        },
        onDownloadCompleted: onDownloadCompleted,
      ),
    );

    downloadingQueue.refresh();
  }

  Future<ApiResponse> downloadFile({
    required String url,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _apiService.downloadFile(
        url,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse(
        data: response.data,
        message: ApiMessage.success,
      );
    } catch (e) {
      // log(e.toString());
      if (e is DioError) {
        return ApiResponse(
          message: ApiMessage.apiError,
          data: e.response?.data,
        );
      }

      return ApiResponse(
        message: ApiMessage.somethingWantWrongError,
      );
    }
  }

  Future _storeFileInSecureStorage({
    required FileType fileType,
    required String fileName,
    required List<int> data,
    required int fileId,
    String? albumOrSermonName,
    String? albumOrSermonImage,
    String? albumOrSermonAuthor,
    int? albumOrSermonId,
  }) async {
    await _secureFileStorageService.saveFile(
      fileData: data,
      fileName: fileName,
      fileId: fileId,
      fileType: fileType,
      parentTitle: albumOrSermonName ?? '',
      parentImage: albumOrSermonImage ?? '',
      parentAuthor: albumOrSermonAuthor ?? '',
      parentId: albumOrSermonId ?? 0,
    );
  }

  Future _getAllDownloadedFiles() async {
    var files = await _secureFileStorageService.getAllFiles();
    downloadedFiles.value = files;
  }

  Future deleteFile({
    required int fileId,
    required FileType fileType,
    required String fileName,
  }) async {
    await _secureFileStorageService.deleteFile(
      fileId: fileId,
      fileType: fileType,
      fileName: fileName,
    );

    _getAllDownloadedFiles();
  }
}
