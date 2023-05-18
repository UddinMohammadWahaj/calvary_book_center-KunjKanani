import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class DailyPromise {
  final int id;
  final String? everydayTitle;
  final String? dailyVideoUrl;
  final String? dailyVidImg;
  final String? dailyPdf;
  final String? dailyPdfImg;
  static final helper = HelperModel<DailyPromise>(
    (map) => DailyPromise.fromMap(map),
  );

  DailyPromise({
    required this.id,
    required this.everydayTitle,
    required this.dailyVideoUrl,
    required this.dailyVidImg,
    required this.dailyPdf,
    required this.dailyPdfImg,
  });

  DailyPromise copyWith({
    int? id,
    String? everydayTitle,
    String? dailyVideoUrl,
    String? dailyVidImg,
    String? dailyPdf,
    String? dailyPdfImg,
  }) {
    return DailyPromise(
      id: id ?? this.id,
      everydayTitle: everydayTitle ?? this.everydayTitle,
      dailyVideoUrl: dailyVideoUrl ?? this.dailyVideoUrl,
      dailyVidImg: dailyVidImg ?? this.dailyVidImg,
      dailyPdf: dailyPdf ?? this.dailyPdf,
      dailyPdfImg: dailyPdfImg ?? this.dailyPdfImg,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'everyday_title': everydayTitle,
      'daily_video_url': dailyVideoUrl,
      'daily_vid_img': dailyVidImg,
      'daily_pdf': dailyPdf,
      'daily_pdf_img': dailyPdfImg,
    };
  }

  factory DailyPromise.fromMap(Map<String, dynamic> map) {
    return DailyPromise(
      id: map['id'].toInt() as int,
      everydayTitle: map['everyday_title'] as String?,
      dailyVideoUrl: map['daily_video_url'] as String?,
      dailyVidImg: map['daily_vid_img'] as String?,
      dailyPdf: map['daily_pdf'] as String?,
      dailyPdfImg: map['daily_pdf_img'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyPromise.fromJson(String source) =>
      DailyPromise.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DailyPromise(id: $id, everyday_title: $everydayTitle, daily_video_url: $dailyVideoUrl, daily_vid_img: $dailyVidImg, daily_pdf: $dailyPdf, daily_pdf_img: $dailyPdfImg)';
  }

  @override
  bool operator ==(covariant DailyPromise other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.everydayTitle == everydayTitle &&
        other.dailyVideoUrl == dailyVideoUrl &&
        other.dailyVidImg == dailyVidImg &&
        other.dailyPdf == dailyPdf &&
        other.dailyPdfImg == dailyPdfImg;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        everydayTitle.hashCode ^
        dailyVideoUrl.hashCode ^
        dailyVidImg.hashCode ^
        dailyPdf.hashCode ^
        dailyPdfImg.hashCode;
  }
}
