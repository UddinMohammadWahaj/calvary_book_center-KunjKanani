import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';
import 'package:flutter/foundation.dart';

class ProductModel {
  final int? id;
  final String? productTitle;
  final String? productDescription;
  final String? productType;
  final int? category;
  final String? categoryName;
  final String? subCategory;
  final String? price;
  final String? discountInPercentage;
  final String? salePrice;
  final String? paymentStatus;
  final int? stock;
  final List<ProductImage>? productImages;
  final List<ProductFeature>? productFeatures;
  final ReviewMatrix? reviewMatrix;
  final bool? isBookmarked;
  int? buyingQuantity;

  static final helper = HelperModel<ProductModel>(
    (map) => ProductModel.fromMap(map),
  );

  ProductModel({
    this.id,
    this.productTitle,
    this.productDescription,
    this.productType,
    this.category,
    this.categoryName,
    this.subCategory,
    this.price,
    this.discountInPercentage,
    this.salePrice,
    this.stock,
    this.paymentStatus,
    this.productImages,
    this.productFeatures,
    this.reviewMatrix,
    this.isBookmarked,
    this.buyingQuantity,
  });

  ProductModel copyWith({
    int? id,
    String? productTitle,
    String? productDescription,
    String? productType,
    int? category,
    String? categoryName,
    String? subCategory,
    String? price,
    String? paymentStatus,
    String? discountInPercentage,
    String? salePrice,
    int? stock,
    List<ProductImage>? productImages,
    List<ProductFeature>? productFeatures,
    ReviewMatrix? reviewMatrix,
    bool? isBookmarked,
    int? buyingQuantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productTitle: productTitle ?? this.productTitle,
      productDescription: productDescription ?? this.productDescription,
      productType: productType ?? this.productType,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      subCategory: subCategory ?? this.subCategory,
      price: price ?? this.price,
      discountInPercentage: discountInPercentage ?? this.discountInPercentage,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      productImages: productImages ?? this.productImages,
      productFeatures: productFeatures ?? this.productFeatures,
      reviewMatrix: reviewMatrix ?? this.reviewMatrix,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      buyingQuantity: buyingQuantity ?? this.buyingQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_title': productTitle ?? '',
      'product_description': productDescription ?? '',
      'product_type': productType ?? '',
      'category': category ?? 0,
      'category_name': categoryName ?? '',
      'sub_category': subCategory ?? '',
      'price': price ?? '',
      'discount_in_percentage': discountInPercentage ?? '',
      'sale_price': salePrice ?? '',
      'stock': stock ?? 0,
      'patment_status': paymentStatus ?? 'N',
      'product_images': productImages != null
          ? productImages!.map((x) => x.toMap()).toList()
          : [],
      'product_features': productFeatures != null
          ? productFeatures!.map((x) => x.toMap()).toList()
          : [],
      'review_matrix': reviewMatrix?.toMap(),
      'is_bookmarked': isBookmarked ?? false,
      'buying_quantity': buyingQuantity ?? 0,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      productTitle: map['product_title'] ?? '',
      productDescription: map['product_description'] ?? '',
      productType: map['product_type'] ?? '',
      category: map['category'] ?? 0,
      categoryName: map['category_name'] ?? '',
      subCategory: map['sub_category'] ?? '',
      price: map['price'] ?? '',
      discountInPercentage: map['discount_in_percentage'] ?? '',
      salePrice: map['sale_price'] ?? '',
      paymentStatus: map['payment_status'] ?? 'N',
      stock: map['stock'] ?? 0,
      productImages: List<ProductImage>.from(
        (map['product_images']).map<ProductImage>(
          (x) => ProductImage.fromMap(x),
        ),
      ),
      productFeatures: List<ProductFeature>.from(
        (map['product_features']).map<ProductFeature>(
          (x) => ProductFeature.fromMap(x),
        ),
      ),
      reviewMatrix: map['review_matrix'] != null
          ? ReviewMatrix.fromMap(map['review_matrix'])
          : null,
      isBookmarked: map['is_bookmarked'] ?? false,
      buyingQuantity: map['buying_quantity'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, product_title: $productTitle, product_description: $productDescription, product_type: $productType, category: $category, category_name: $categoryName, sub_category: $subCategory, price: $price, discount_in_percentage: $discountInPercentage, sale_price: $salePrice, stock: $stock, product_images: $productImages, product_features: $productFeatures review_matrix: $reviewMatrix is_bookmarked: $isBookmarked, buying_quantity: $buyingQuantity)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.productTitle == productTitle &&
        other.productDescription == productDescription &&
        other.productType == productType &&
        other.category == category &&
        other.categoryName == categoryName &&
        other.subCategory == subCategory &&
        other.price == price &&
        other.discountInPercentage == discountInPercentage &&
        other.salePrice == salePrice &&
        other.stock == stock &&
        listEquals(other.productImages, productImages) &&
        listEquals(other.productFeatures, productFeatures) &&
        other.paymentStatus == paymentStatus &&
        other.reviewMatrix == reviewMatrix &&
        other.isBookmarked == isBookmarked &&
        other.buyingQuantity == buyingQuantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productTitle.hashCode ^
        productDescription.hashCode ^
        productType.hashCode ^
        category.hashCode ^
        categoryName.hashCode ^
        subCategory.hashCode ^
        price.hashCode ^
        discountInPercentage.hashCode ^
        salePrice.hashCode ^
        stock.hashCode ^
        productImages.hashCode ^
        paymentStatus.hashCode ^
        productFeatures.hashCode ^
        reviewMatrix.hashCode ^
        isBookmarked.hashCode ^
        buyingQuantity.hashCode;
  }
}

class ProductImage {
  final int id;
  final String productImg;
  final int product;
  ProductImage({
    required this.id,
    required this.productImg,
    required this.product,
  });

  ProductImage copyWith({
    int? id,
    String? productImg,
    int? product,
  }) {
    return ProductImage(
      id: id ?? this.id,
      productImg: productImg ?? this.productImg,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_img': productImg,
      'product': product,
    };
  }

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      id: map['id'] ?? 0,
      productImg: map['product_img'] ?? '',
      product: map['product'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductImage.fromJson(String source) =>
      ProductImage.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProductImage(id: $id, product_img: $productImg, product: $product)';

  @override
  bool operator ==(covariant ProductImage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.productImg == productImg &&
        other.product == product;
  }

  @override
  int get hashCode => id.hashCode ^ productImg.hashCode ^ product.hashCode;
}

class ProductFeature {
  final int id;
  final String name;
  final String value;
  final int product;
  ProductFeature({
    required this.id,
    required this.name,
    required this.value,
    required this.product,
  });

  ProductFeature copyWith({
    int? id,
    String? name,
    String? value,
    int? product,
  }) {
    return ProductFeature(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'value': value,
      'product': product,
    };
  }

  factory ProductFeature.fromMap(Map<String, dynamic> map) {
    return ProductFeature(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      value: map['value'] ?? '',
      product: map['product'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductFeature.fromJson(String source) =>
      ProductFeature.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductFeature(id: $id, name: $name, value: $value, product: $product)';
  }

  @override
  bool operator ==(covariant ProductFeature other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.value == value &&
        other.product == product;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ value.hashCode ^ product.hashCode;
  }
}

class ReviewMatrix {
  final double? avg;
  final int? fiveStars;
  final int? fourStars;
  final int? threeStars;
  final int? twostars;
  final int? onestar;
  ReviewMatrix({
    this.avg,
    this.fiveStars,
    this.fourStars,
    this.threeStars,
    this.twostars,
    this.onestar,
  });

  ReviewMatrix copyWith({
    double? avg,
    int? fiveStars,
    int? fourStars,
    int? threeStars,
    int? twostars,
    int? onestar,
  }) {
    return ReviewMatrix(
      avg: avg ?? this.avg,
      fiveStars: fiveStars ?? this.fiveStars,
      fourStars: fourStars ?? this.fourStars,
      threeStars: threeStars ?? this.threeStars,
      twostars: twostars ?? this.twostars,
      onestar: onestar ?? this.onestar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Avg': avg,
      '5_stars': fiveStars,
      '4_stars': fourStars,
      '3_stars': threeStars,
      '2_stars': twostars,
      '1_star': onestar,
    };
  }

  factory ReviewMatrix.fromMap(Map<String, dynamic> map) {
    return ReviewMatrix(
      avg: double.parse(map['Avg'].toString()),
      fiveStars: map['5 stars'],
      fourStars: map['4 stars'],
      threeStars: map['3 stars'],
      twostars: map['2 stars'],
      onestar: map['1 star'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewMatrix.fromJson(String source) =>
      ReviewMatrix.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewMatrix(Avg: $avg, 5_stars: $fiveStars, 4_stars: $fourStars, 3_stars: $threeStars, 2_stars: $twostars, 1_star: $onestar)';
  }

  @override
  bool operator ==(covariant ReviewMatrix other) {
    if (identical(this, other)) return true;

    return other.avg == avg &&
        other.fiveStars == fiveStars &&
        other.fourStars == fourStars &&
        other.threeStars == threeStars &&
        other.twostars == twostars &&
        other.onestar == onestar;
  }

  @override
  int get hashCode {
    return avg.hashCode ^
        fiveStars.hashCode ^
        fourStars.hashCode ^
        threeStars.hashCode ^
        twostars.hashCode ^
        onestar.hashCode;
  }
}
