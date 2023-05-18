import 'package:bookcenter/service/storage_services/secure_file_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum DownloadStatus { pending, downloading, completed, failed }

class DownloadingModel {
  int id;
  FileType fileType;
  String url;
  String fileName;
  String parentName;
  String parentImage;
  String parentAuthor;
  int parentId;
  DownloadStatus downloadStatus;
  double downloadProgress;
  ProgressCallback onReceiveProgress;
  VoidCallback? onDownloadCompleted;

  DownloadingModel({
    required this.id,
    required this.fileType,
    required this.url,
    required this.fileName,
    required this.onReceiveProgress,
    this.downloadStatus = DownloadStatus.pending,
    this.downloadProgress = 0,
    this.onDownloadCompleted,
    this.parentName = '',
    this.parentImage = '',
    this.parentAuthor = '',
    this.parentId = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileType': fileType,
      'url': url,
      'fileName': fileName,
      'downloadStatus': downloadStatus,
      'downloadProgress': downloadProgress,
      'onReceiveProgress': onReceiveProgress,
      'onDownloadCompleted': onDownloadCompleted,
      'parentName': parentName,
      'parentImage': parentImage,
      'parentAuthor': parentAuthor,
      'parentId': parentId,
    };
  }

  factory DownloadingModel.fromMap(Map<String, dynamic> map) {
    return DownloadingModel(
      id: map['id'],
      fileType: map['fileType'],
      url: map['url'],
      fileName: map['fileName'],
      downloadStatus: map['downloadStatus'],
      downloadProgress: map['downloadProgress'],
      onReceiveProgress: map['onReceiveProgress'],
      onDownloadCompleted: map['onDownloadCompleted'],
      parentName: map['parentName'],
      parentImage: map['parentImage'],
      parentAuthor: map['parentAuthor'],
      parentId: map['parentId'],
    );
  }
}
