import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String related;
  final String image;
  final String created;
  final int category;
  static final helper = HelperModel<NotificationModel>(
    (map) => NotificationModel.fromMap(map),
  );

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.related,
    required this.image,
    required this.created,
    required this.category,
  });

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    String? related,
    String? image,
    String? created,
    int? category,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      related: related ?? this.related,
      image: image ?? this.image,
      created: created ?? this.created,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'related': related,
      'image': image,
      'created': created,
      'category': category,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      related: map['related'] ?? '',
      image: map['image'] ?? '',
      created: map['created'] ?? '',
      category: map['category'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, related: $related, image: $image, created: $created, category: $category)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.body == body &&
        other.related == related &&
        other.image == image &&
        other.created == created &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        related.hashCode ^
        image.hashCode ^
        created.hashCode ^
        category.hashCode;
  }
}
