import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class CouponModel {
  final int? id;
  final String? campaignName;
  final String? code;
  final String? productType;
  final String? category;
  final String? subCategory;
  final double? discount;
  final double? minimumAmount;
  final String? createdAt;
  final String? expire;
  final int? quantity;
  final bool? active;
  static final helper = HelperModel<CouponModel>(
    (map) => CouponModel.fromMap(map),
  );
  double? discountAmount;

  CouponModel({
    this.id,
    this.campaignName,
    this.code,
    this.productType,
    this.category,
    this.subCategory,
    this.discount,
    this.minimumAmount,
    this.createdAt,
    this.expire,
    this.quantity,
    this.active,
    this.discountAmount,
  });

  CouponModel copyWith({
    int? id,
    String? campaignName,
    String? code,
    String? productType,
    String? category,
    String? subCategory,
    double? discount,
    double? minimumAmount,
    String? createdAt,
    String? expire,
    int? quantity,
    bool? active,
    double? discountAmount,
  }) {
    return CouponModel(
      id: id ?? this.id,
      campaignName: campaignName ?? this.campaignName,
      code: code ?? this.code,
      productType: productType ?? this.productType,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      discount: discount ?? this.discount,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      createdAt: createdAt ?? this.createdAt,
      expire: expire ?? this.expire,
      quantity: quantity ?? this.quantity,
      active: active ?? this.active,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'campaign_name': campaignName,
      'code': code,
      'product_type': productType,
      'category': category,
      'sub_category': subCategory,
      'discount': discount,
      'minimum_amount': minimumAmount,
      'created_at': createdAt,
      'expire': expire,
      'quantity': quantity,
      'active': active,
      'discount_amount': discountAmount,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['id'] ?? 0,
      campaignName: map['campaign_name'] ?? '',
      code: map['code'] ?? '',
      productType: map['product_type'] ?? '',
      category: map['category'] ?? '',
      subCategory: map['sub_category'] ?? '',
      discount: map['discount'] ?? 0,
      minimumAmount: map['minimum_amount'] ?? 0,
      createdAt: map['created_at'] ?? '',
      expire: map['expire'] ?? '',
      quantity: map['quantity'] ?? 0,
      active: map['active'] ?? false,
      discountAmount: map['discount_amount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CouponModel(id: $id, campaign_name: $campaignName, code: $code, product_type: $productType, category: $category, sub_category: $subCategory, discount: $discount, minimum_amount: $minimumAmount, created_at: $createdAt, expire: $expire, quantity: $quantity, active: $active, discount_amount: $discountAmount)';
  }

  @override
  bool operator ==(covariant CouponModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.campaignName == campaignName &&
        other.code == code &&
        other.productType == productType &&
        other.category == category &&
        other.subCategory == subCategory &&
        other.discount == discount &&
        other.minimumAmount == minimumAmount &&
        other.createdAt == createdAt &&
        other.expire == expire &&
        other.quantity == quantity &&
        other.active == active &&
        other.discountAmount == discountAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        campaignName.hashCode ^
        code.hashCode ^
        productType.hashCode ^
        category.hashCode ^
        subCategory.hashCode ^
        discount.hashCode ^
        minimumAmount.hashCode ^
        createdAt.hashCode ^
        expire.hashCode ^
        quantity.hashCode ^
        active.hashCode ^
        discountAmount.hashCode;
  }
}
