import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';
import 'package:flutter/foundation.dart';

class CategoryModel {
  final int id;
  final int? sortOrder;
  final String? categoryTitle;
  final String? categoryImg;
  final String? categoryIcon;
  final List<SubCategory> subCategories;
  static final helper = HelperModel<CategoryModel>(
    (map) => CategoryModel.fromMap(map),
  );

  CategoryModel({
    required this.id,
    required this.sortOrder,
    required this.categoryTitle,
    required this.categoryImg,
    required this.categoryIcon,
    required this.subCategories,
  });

  CategoryModel copyWith({
    int? id,
    int? sortOrder,
    String? categoryTitle,
    String? categoryImg,
    String? categoryIcon,
    List<SubCategory>? subCategories,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      sortOrder: sortOrder ?? this.sortOrder,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      categoryImg: categoryImg ?? this.categoryImg,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      subCategories: subCategories ?? this.subCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sort_order': sortOrder,
      'category_title': categoryTitle,
      'category_img': categoryImg,
      'category_icon': categoryIcon,
      'sub_categories': subCategories.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'].toInt() as int,
      sortOrder: map['sort_order'],
      categoryTitle: map['category_title'],
      categoryImg: map['category_img'],
      categoryIcon: map['category_icon'],
      subCategories: List<SubCategory>.from(
        (map['sub_categories']).map<SubCategory>(
          (x) => SubCategory.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(id: $id, sort_order: $sortOrder, category_title: $categoryTitle, category_img: $categoryImg, category_icon: $categoryIcon, sub_categories: $subCategories)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sortOrder == sortOrder &&
        other.categoryTitle == categoryTitle &&
        other.categoryImg == categoryImg &&
        other.categoryIcon == categoryIcon &&
        listEquals(other.subCategories, subCategories);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sortOrder.hashCode ^
        categoryTitle.hashCode ^
        categoryImg.hashCode ^
        categoryIcon.hashCode ^
        subCategories.hashCode;
  }
}

class SubCategory {
  final int id;
  final String? name;
  final String? image;
  SubCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  SubCategory copyWith({
    int? id,
    String? name,
    String? image,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map['id'].toInt() as int,
      name: map['name'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubCategory.fromJson(String source) =>
      SubCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Sub_categorie(id: $id, name: $name, image: $image)';

  @override
  bool operator ==(covariant SubCategory other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.image == image;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ image.hashCode;
}
