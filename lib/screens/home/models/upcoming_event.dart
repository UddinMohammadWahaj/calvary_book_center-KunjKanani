import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class UpcomingEvent {
  final int id;
  final String? productName;
  final String? promoTitle;
  final String? promoDescription;
  final String? promoVideo;
  final String? promoImg;
  final bool? navigationStatus;
  final int? productId;
  static final helper = HelperModel<UpcomingEvent>(
    (map) => UpcomingEvent.fromMap(map),
  );

  UpcomingEvent({
    required this.id,
    required this.productName,
    required this.promoTitle,
    required this.promoDescription,
    required this.promoVideo,
    required this.promoImg,
    required this.navigationStatus,
    required this.productId,
  });

  UpcomingEvent copyWith({
    int? id,
    String? productName,
    String? promoTitle,
    String? promoDescription,
    String? promoVideo,
    String? promoImg,
    bool? navigationStatus,
    int? productId,
  }) {
    return UpcomingEvent(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      promoTitle: promoTitle ?? this.promoTitle,
      promoDescription: promoDescription ?? this.promoDescription,
      promoVideo: promoVideo ?? this.promoVideo,
      promoImg: promoImg ?? this.promoImg,
      navigationStatus: navigationStatus ?? this.navigationStatus,
      productId: productId ?? this.productId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_name': productName,
      'promo_title': promoTitle,
      'promo_description': promoDescription,
      'promo_video': promoVideo,
      'promo_img': promoImg,
      'navigation_status': navigationStatus,
      'product_id': productId,
    };
  }

  factory UpcomingEvent.fromMap(Map<String, dynamic> map) {
    return UpcomingEvent(
      id: map['id'],
      productName: map['product_name'],
      promoTitle: map['promo_title'],
      promoDescription: map['promo_description'],
      promoVideo: map['promo_video'],
      promoImg: map['promo_img'],
      navigationStatus: map['navigation_status'],
      productId: map['product_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpcomingEvent.fromJson(String source) =>
      UpcomingEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UpcomingEvent(id: $id, product_name: $productName, promo_title: $promoTitle, promo_description: $promoDescription, promo_video: $promoVideo, promo_img: $promoImg, navigation_status: $navigationStatus, product_id: $productId)';
  }

  @override
  bool operator ==(covariant UpcomingEvent other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.productName == productName &&
        other.promoTitle == promoTitle &&
        other.promoDescription == promoDescription &&
        other.promoVideo == promoVideo &&
        other.promoImg == promoImg &&
        other.navigationStatus == navigationStatus &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productName.hashCode ^
        promoTitle.hashCode ^
        promoDescription.hashCode ^
        promoVideo.hashCode ^
        promoImg.hashCode ^
        navigationStatus.hashCode ^
        productId.hashCode;
  }
}
