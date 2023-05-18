import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class ReviewModel {
  final int id;
  final int? product;
  final String? title;
  final String? ratings;
  final String? description;
  final String? user;
  static final helper = HelperModel<ReviewModel>(
    (map) => ReviewModel.fromMap(map),
  );

  ReviewModel({
    required this.id,
    required this.product,
    required this.title,
    required this.ratings,
    required this.description,
    required this.user,
  });

  ReviewModel copyWith({
    int? id,
    int? product,
    String? title,
    String? ratings,
    String? description,
    String? user,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      product: product ?? this.product,
      title: title ?? this.title,
      ratings: ratings ?? this.ratings,
      description: description ?? this.description,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product,
      'title': title,
      'ratings': ratings,
      'description': description,
      'user': user,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? 0,
      product: map['product'] ?? 0,
      title: map['title'] ?? '',
      ratings: map['ratings'] ?? '',
      description: map['description'] ?? '',
      user: map['user'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReviewModel(id: $id, product: $product, title: $title, ratings: $ratings, description: $description, user: $user)';
  }

  @override
  bool operator ==(covariant ReviewModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.product == product &&
        other.title == title &&
        other.ratings == ratings &&
        other.description == description &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        product.hashCode ^
        title.hashCode ^
        ratings.hashCode ^
        description.hashCode ^
        user.hashCode;
  }
}
