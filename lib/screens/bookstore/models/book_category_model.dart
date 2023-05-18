import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class BookCategoryModel {
  final int id;
  final String? categoryTitle;
  final String? categoryImg;
  final String? categoryIcon;
  final int? bookCount;
  static final helper = HelperModel(
    (map) => BookCategoryModel.fromMap(map),
  );

  BookCategoryModel({
    required this.id,
    required this.categoryTitle,
    required this.categoryImg,
    required this.categoryIcon,
    required this.bookCount,
  });

  BookCategoryModel copyWith({
    int? id,
    String? categoryTitle,
    String? categoryImg,
    String? categoryIcon,
    int? bookCount,
  }) {
    return BookCategoryModel(
      id: id ?? this.id,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      categoryImg: categoryImg ?? this.categoryImg,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      bookCount: bookCount ?? this.bookCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_title': categoryTitle,
      'category_img': categoryImg,
      'category_icon': categoryIcon,
      'book_count': bookCount,
    };
  }

  factory BookCategoryModel.fromMap(Map<String, dynamic> map) {
    return BookCategoryModel(
      id: map['id'] ?? 0,
      categoryTitle: map['category_title'] ?? '',
      categoryImg: map['category_img'] ?? '',
      categoryIcon: map['category_icon'] ?? '',
      bookCount: map['book_count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookCategoryModel.fromJson(String source) =>
      BookCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookCategoryModel(id: $id, category_title: $categoryTitle, category_img: $categoryImg, category_icon: $categoryIcon, book_count: $bookCount)';
  }

  @override
  bool operator ==(covariant BookCategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.categoryTitle == categoryTitle &&
        other.categoryImg == categoryImg &&
        other.categoryIcon == categoryIcon &&
        other.bookCount == bookCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        categoryTitle.hashCode ^
        categoryImg.hashCode ^
        categoryIcon.hashCode ^
        bookCount.hashCode;
  }
}
