import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';
import 'package:flutter/foundation.dart';

class OrderModel {
  final int id;
  final List<Item> items;
  final String address;
  final String orderDate;
  final double totalAmount;
  final double tip;
  final String paymentType;
  final String paymentStatus;
  final String deliveryStatus;
  final String transactionId;
  final int user;
  static final helper = HelperModel(
    (map) => OrderModel.fromMap(map),
  );

  OrderModel({
    required this.id,
    required this.items,
    required this.address,
    required this.orderDate,
    required this.totalAmount,
    required this.tip,
    required this.paymentType,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.transactionId,
    required this.user,
  });

  OrderModel copyWith({
    int? id,
    List<Item>? items,
    String? address,
    String? orderDate,
    double? totalAmount,
    double? tip,
    String? paymentType,
    String? paymentStatus,
    String? deliveryStatus,
    String? transactionId,
    int? user,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      address: address ?? this.address,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      tip: tip ?? this.tip,
      paymentType: paymentType ?? this.paymentType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      transactionId: transactionId ?? this.transactionId,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'items': items.map((x) => x.toMap()).toList(),
      'address': address,
      'order_date': orderDate,
      'total_amount': totalAmount,
      'tip': tip,
      'payment_type': paymentType,
      'payment_status': paymentStatus,
      'delivery_status': deliveryStatus,
      'transaction_id': transactionId,
      'user': user,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? 0,
      items: List<Item>.from(
        (map['items']).map<Item>(
          (x) => Item.fromMap(x),
        ),
      ),
      address: map['address'] ?? '',
      orderDate: map['order_date'] ?? '',
      totalAmount: map['total_amount'] ?? 0,
      tip: map['tip'] ?? 0,
      paymentType: map['payment_type'] ?? '',
      paymentStatus: map['payment_status'] ?? '',
      deliveryStatus: map['delivery_status'] ?? '',
      transactionId: map['transaction_id'] ?? '',
      user: map['user'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(id: $id, items: $items, address: $address, order_date: $orderDate, total_amount: $totalAmount, tip: $tip, payment_type: $paymentType, payment_status: $paymentStatus, delivery_status: $deliveryStatus, transaction_id: $transactionId, user: $user)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.items, items) &&
        other.address == address &&
        other.orderDate == orderDate &&
        other.totalAmount == totalAmount &&
        other.tip == tip &&
        other.paymentType == paymentType &&
        other.paymentStatus == paymentStatus &&
        other.deliveryStatus == deliveryStatus &&
        other.transactionId == transactionId &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        items.hashCode ^
        address.hashCode ^
        orderDate.hashCode ^
        totalAmount.hashCode ^
        tip.hashCode ^
        paymentType.hashCode ^
        paymentStatus.hashCode ^
        deliveryStatus.hashCode ^
        transactionId.hashCode ^
        user.hashCode;
  }
}

class Item {
  final int id;
  final String productName;
  final String productImage;
  final int productId;
  final double price;
  final int quantity;
  final int cartOrder;
  Item({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.cartOrder,
  });

  Item copyWith({
    int? id,
    String? productName,
    String? productImage,
    int? productId,
    double? price,
    int? quantity,
    int? cartOrder,
  }) {
    return Item(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      cartOrder: cartOrder ?? this.cartOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_name': productName,
      'product_image': productImage,
      'product_id': productId,
      'price': price,
      'quantity': quantity,
      'cart_order': cartOrder,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? 0,
      productName: map['product_name'] ?? '',
      productImage: map['product_image'] ?? '',
      productId: map['product_id'] ?? 0,
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 0,
      cartOrder: map['cart_order'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(id: $id, product_name: $productName, product_image: $productImage, product_id: $productId, price: $price, quantity: $quantity, cart_order: $cartOrder)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.productName == productName &&
        other.productImage == productImage &&
        other.productId == productId &&
        other.price == price &&
        other.quantity == quantity &&
        other.cartOrder == cartOrder;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productName.hashCode ^
        productImage.hashCode ^
        productId.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        cartOrder.hashCode;
  }
}
