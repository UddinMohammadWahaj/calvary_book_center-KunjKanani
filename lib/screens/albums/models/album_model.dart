import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';
import 'package:flutter/foundation.dart';

class AlbumModel {
  final int? id;
  final String? artist;
  final String? albumTitle;
  final String? albumTeluguTitle;
  final String? albumLogo;
  final String? albumSlider;
  final String? price;
  List<Song> songs;
  String? paymentStatus;
  final String? paymentType;
  static final helper = HelperModel<AlbumModel>(
    (map) => AlbumModel.fromMap(map),
  );

  AlbumModel(
      {this.id,
      this.artist,
      this.albumTitle,
      this.albumTeluguTitle,
      this.albumLogo,
      this.price,
      required this.songs,
      this.paymentStatus,
      this.paymentType,
      this.albumSlider});

  AlbumModel copyWith({
    int? id,
    String? artist,
    String? albumTitle,
    String? albumTeluguTitle,
    String? albumLogo,
    String? albumSlider,
    String? price,
    List<Song>? songs,
    String? paymentStatus,
    String? paymentType,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      artist: artist ?? this.artist,
      albumTitle: albumTitle ?? this.albumTitle,
      albumTeluguTitle: albumTeluguTitle ?? this.albumTeluguTitle,
      albumLogo: albumLogo ?? this.albumLogo,
      albumSlider: albumSlider ?? this.albumSlider,
      price: price ?? this.price,
      songs: songs ?? this.songs,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentType: paymentType ?? this.paymentType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'artist': artist,
      'album_title': albumTitle,
      'album_telugu_title': albumTeluguTitle,
      'album_logo': albumLogo,
      'album_slider': albumSlider,
      'price': price,
      'songs': songs.map((x) => x.toMap()).toList(),
      'payment_status': paymentStatus,
      'payment_type': paymentType,
    };
  }

  factory AlbumModel.fromMap(Map<String, dynamic> map) {
    return AlbumModel(
      id: map['id'].toInt(),
      artist: map['artist'] as String?,
      albumTitle: map['album_title'] as String?,
      albumTeluguTitle: map['album_telugu_title'] as String?,
      albumLogo: map['album_logo'] as String?,
      albumSlider: map['album_slider'] as String?,
      price: map['price'] as String?,
      songs: List<Song>.from(
        (map['songs']).map<Song>(
          (x) => Song.fromMap(x as Map<String, dynamic>),
        ),
      ),
      paymentStatus: map['payment_status'] as String?,
      paymentType: map['payment_type'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumModel.fromJson(String source) =>
      AlbumModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AlbumModel(id: $id, artist: $artist, album_title: $albumTitle, album_telugu_title: $albumTeluguTitle, album_logo: $albumLogo, album_slider: $albumSlider, price: $price, songs: $songs, payment_status: $paymentStatus, payment_type: $paymentType)';
  }

  @override
  bool operator ==(covariant AlbumModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.artist == artist &&
        other.albumTitle == albumTitle &&
        other.albumTeluguTitle == albumTeluguTitle &&
        other.albumLogo == albumLogo &&
        other.albumSlider == albumSlider &&
        other.price == price &&
        listEquals(other.songs, songs) &&
        other.paymentStatus == paymentStatus &&
        other.paymentType == paymentType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        artist.hashCode ^
        albumTitle.hashCode ^
        albumTeluguTitle.hashCode ^
        albumLogo.hashCode ^
        albumSlider.hashCode ^
        price.hashCode ^
        songs.hashCode ^
        paymentStatus.hashCode ^
        paymentType.hashCode;
  }
}

class Song {
  final int id;
  final int? album;
  final String? songTitle;
  final String? songTeluguTitle;
  final String? song;
  final String? youtubeLink;
  bool? isDownloaded;

  Song({
    required this.id,
    this.album,
    required this.songTitle,
    this.songTeluguTitle,
    this.song,
    this.youtubeLink,
    this.isDownloaded = false,
  });

  Song copyWith({
    int? id,
    int? album,
    String? songTitle,
    String? songTeluguTitle,
    String? song,
    String? youtubeLink,
    bool? isDownloaded,
  }) {
    return Song(
      id: id ?? this.id,
      album: album ?? this.album,
      songTitle: songTitle ?? this.songTitle,
      songTeluguTitle: songTeluguTitle ?? this.songTeluguTitle,
      song: song ?? this.song,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'album': album,
      'song_title': songTitle,
      'song_telugu_title': songTeluguTitle,
      'song': song,
      'youtube_link': youtubeLink,
      'is_downloaded': isDownloaded,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'].toInt() as int,
      album: map['album'].toInt() as int,
      songTitle: map['song_title'] as String?,
      songTeluguTitle: map['song_telugu_title'] as String?,
      song: map['song'] as String?,
      youtubeLink: map['youtube_link'] as String?,
      isDownloaded: map['is_downloaded'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) =>
      Song.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Song(id: $id, album: $album, song_title: $songTitle, song_telugu_title: $songTeluguTitle, song: $song, youtube_link: $youtubeLink, is_downloaded: $isDownloaded)';
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.album == album &&
        other.songTitle == songTitle &&
        other.songTeluguTitle == songTeluguTitle &&
        other.song == song &&
        other.youtubeLink == youtubeLink &&
        other.isDownloaded == isDownloaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        album.hashCode ^
        songTitle.hashCode ^
        songTeluguTitle.hashCode ^
        song.hashCode ^
        youtubeLink.hashCode ^
        isDownloaded.hashCode;
  }
}
