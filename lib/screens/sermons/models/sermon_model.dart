import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';
import 'package:flutter/foundation.dart';

class SermonModel {
  final int? id;
  final String? sermonsArtist;
  final String? sermonsTitle;
  final String? sermonsTeluguTitle;
  final String? sermonsLogo;
  final String? sermonsSliderVid;
  final int? sermonsCategory;
  final String? sermonsSliderImg;
  final String? price;
  List<VideoSong> videoSongs;
  final String? paymentType;
  String? paymentStatus;
  bool isPurchased;

  static final helper = HelperModel<SermonModel>(
    (map) => SermonModel.fromMap(map),
  );

  SermonModel({
    this.id,
    this.sermonsArtist,
    this.sermonsTitle,
    this.sermonsTeluguTitle,
    this.sermonsLogo,
    this.sermonsSliderVid,
    this.sermonsCategory,
    this.sermonsSliderImg,
    this.price,
    required this.videoSongs,
    this.paymentType,
    this.paymentStatus,
    this.isPurchased = false,
  });

  SermonModel copyWith({
    int? id,
    String? sermonsArtist,
    String? sermonsTitle,
    String? sermonsTeluguTitle,
    String? sermonsLogo,
    String? sermonsSliderVid,
    int? sermonsCategory,
    String? sermonsSliderImg,
    String? price,
    List<VideoSong>? videoSongs,
    String? paymentType,
    String? paymentStatus,
    bool? isPurchased,
  }) {
    return SermonModel(
      id: id ?? this.id,
      sermonsArtist: sermonsArtist ?? this.sermonsArtist,
      sermonsTitle: sermonsTitle ?? this.sermonsTitle,
      sermonsTeluguTitle: sermonsTeluguTitle ?? this.sermonsTeluguTitle,
      sermonsLogo: sermonsLogo ?? this.sermonsLogo,
      sermonsSliderVid: sermonsSliderVid ?? this.sermonsSliderVid,
      sermonsCategory: sermonsCategory ?? this.sermonsCategory,
      sermonsSliderImg: sermonsSliderImg ?? this.sermonsSliderImg,
      price: price ?? this.price,
      videoSongs: videoSongs ?? this.videoSongs,
      paymentType: paymentType ?? this.paymentType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sermons_artist': sermonsArtist,
      'sermons_title': sermonsTitle,
      'sermons_telugu_title': sermonsTeluguTitle,
      'sermons_logo': sermonsLogo,
      'sermons_slider_vid': sermonsSliderVid,
      'category': sermonsCategory,
      'sermons_slider_img': sermonsSliderImg,
      'price': price,
      'video_songs': videoSongs,
      'payment_type': paymentType,
      'payment_status': paymentStatus,
      'is_purchased': isPurchased,
    };
  }

  factory SermonModel.fromMap(Map<String, dynamic> map) {
    return SermonModel(
      id: map['id'].toInt() as int,
      sermonsArtist: map['sermons_artist'] as String?,
      sermonsTitle: map['sermons_title'] as String?,
      sermonsTeluguTitle: map['sermons_telugu_title'] as String?,
      sermonsLogo: map['sermons_logo'] as String?,
      sermonsSliderVid: map['sermons_slider_vid'] as String?,
      sermonsCategory: map['category'] as int?,
      sermonsSliderImg: map['sermons_slider_img'] as String?,
      price: map['price'] as String?,
      videoSongs: List<VideoSong>.from(
        map['video_songs']?.map(
          (x) => VideoSong.fromMap(x),
        ),
      ),
      paymentType: map['payment_type'] as String?,
      paymentStatus: map['payment_status'] as String?,
      isPurchased:
          map['is_purchased'] == null ? false : map['is_purchased'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SermonModel.fromJson(String source) =>
      SermonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SermonModel(id: $id, sermons_artist: $sermonsArtist, sermons_title: $sermonsTitle, sermons_telugu_title: $sermonsTeluguTitle, sermons_logo: $sermonsLogo, sermons_slider_vid: $sermonsSliderVid, sermons_category: $sermonsCategory, sermons_slider_img: $sermonsSliderImg, price: $price, video_songs: $videoSongs, payment_type: $paymentType, payment_status: $paymentStatus, is_purchase: $isPurchased)';
  }

  @override
  bool operator ==(covariant SermonModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sermonsArtist == sermonsArtist &&
        other.sermonsTitle == sermonsTitle &&
        other.sermonsTeluguTitle == sermonsTeluguTitle &&
        other.sermonsLogo == sermonsLogo &&
        other.sermonsSliderVid == sermonsSliderVid &&
        other.sermonsCategory == sermonsCategory &&
        other.sermonsSliderImg == sermonsSliderImg &&
        other.price == price &&
        listEquals(other.videoSongs, videoSongs) &&
        other.paymentType == paymentType &&
        other.paymentStatus == paymentStatus &&
        other.isPurchased == isPurchased;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sermonsArtist.hashCode ^
        sermonsTitle.hashCode ^
        sermonsTeluguTitle.hashCode ^
        sermonsLogo.hashCode ^
        sermonsSliderVid.hashCode ^
        sermonsCategory.hashCode ^
        sermonsSliderImg.hashCode ^
        price.hashCode ^
        videoSongs.hashCode ^
        paymentType.hashCode ^
        paymentStatus.hashCode ^
        isPurchased.hashCode;
  }
}

class VideoSong {
  final int id;
  final String? songTitle;
  final String? songTeluguTitle;
  final String? song;
  final String? youtubeLink;
  final int? sermonsAlbum;
  bool? isDownloaded;

  VideoSong({
    required this.id,
    required this.songTitle,
    this.songTeluguTitle,
    this.song,
    this.youtubeLink,
    this.sermonsAlbum,
    this.isDownloaded = false,
  });

  VideoSong copyWith({
    int? id,
    String? songTitle,
    String? songTeluguTitle,
    String? song,
    String? youtubeLink,
    int? sermonsAlbum,
    bool? isDownloaded,
  }) {
    return VideoSong(
      id: id ?? this.id,
      songTitle: songTitle ?? this.songTitle,
      songTeluguTitle: songTeluguTitle ?? this.songTeluguTitle,
      song: song ?? this.song,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      sermonsAlbum: sermonsAlbum ?? this.sermonsAlbum,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_title': songTitle,
      'song_telugu_title': songTeluguTitle,
      'song': song,
      'youtube_link': youtubeLink,
      'sermons_album': sermonsAlbum,
      'is_downloaded': isDownloaded ?? false,
    };
  }

  factory VideoSong.fromMap(Map<String, dynamic> map) {
    return VideoSong(
      id: map['id'].toInt() as int,
      songTitle: map['song_title'] as String?,
      songTeluguTitle: map['song_telugu_title'] as String?,
      song: map['song'] as String?,
      youtubeLink: map['youtube_link'] as String?,
      sermonsAlbum: map['sermons_album'].toInt() as int,
      isDownloaded:
          map['is_downloaded'] == null ? false : map['is_downloaded'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoSong.fromJson(String source) =>
      VideoSong.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Video_song(id: $id, song_title: $songTitle, song_telugu_title: $songTeluguTitle, song: $song, youtube_link: $youtubeLink, sermons_album: $sermonsAlbum, is_downloaded: $isDownloaded)';
  }

  @override
  bool operator ==(covariant VideoSong other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.songTitle == songTitle &&
        other.songTeluguTitle == songTeluguTitle &&
        other.song == song &&
        other.youtubeLink == youtubeLink &&
        other.sermonsAlbum == sermonsAlbum &&
        other.isDownloaded == isDownloaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        songTitle.hashCode ^
        songTeluguTitle.hashCode ^
        song.hashCode ^
        youtubeLink.hashCode ^
        sermonsAlbum.hashCode ^
        isDownloaded.hashCode;
  }
}
