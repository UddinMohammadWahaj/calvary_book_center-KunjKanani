import 'dart:convert';

class PaymentModel {
  final int orderId;
  final RpayData rpayData;

  PaymentModel({
    required this.orderId,
    required this.rpayData,
  });

  PaymentModel copyWith({
    int? orderId,
    RpayData? rpayData,
  }) {
    return PaymentModel(
      orderId: orderId ?? this.orderId,
      rpayData: rpayData ?? this.rpayData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order_id': orderId,
      'rpay_data': rpayData.toMap(),
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      orderId: map['order_id'],
      rpayData: RpayData.fromMap(map['rpay_data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(json.decode(source));

  @override
  String toString() => 'OrderModel(order_id: $orderId, rpay_data: $rpayData)';

  @override
  bool operator ==(covariant PaymentModel other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId && other.rpayData == rpayData;
  }

  @override
  int get hashCode => orderId.hashCode ^ rpayData.hashCode;
}

class RpayData {
  final String description;
  final String image;
  final String currency;
  final String key;
  final double amount;
  final String name;
  final String orderId;
  final Prefill prefill;
  final Theme theme;
  RpayData({
    required this.description,
    required this.image,
    required this.currency,
    required this.key,
    required this.amount,
    required this.name,
    required this.orderId,
    required this.prefill,
    required this.theme,
  });

  RpayData copyWith({
    String? description,
    String? image,
    String? currency,
    String? key,
    double? amount,
    String? name,
    String? orderId,
    Prefill? prefill,
    Theme? theme,
  }) {
    return RpayData(
      description: description ?? this.description,
      image: image ?? this.image,
      currency: currency ?? this.currency,
      key: key ?? this.key,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      orderId: orderId ?? this.orderId,
      prefill: prefill ?? this.prefill,
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'image': image,
      'currency': currency,
      'key': key,
      'amount': amount,
      'name': name,
      'order_id': orderId,
      'prefill': prefill.toMap(),
      'theme': theme.toMap(),
    };
  }

  factory RpayData.fromMap(Map<String, dynamic> map) {
    return RpayData(
      description: map['description'],
      image: map['image'],
      currency: map['currency'],
      key: map['key'],
      amount: map['amount'],
      name: map['name'],
      orderId: map['order_id'].toString(),
      prefill: Prefill.fromMap(map['prefill']),
      theme: Theme.fromMap(map['theme']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RpayData.fromJson(String source) =>
      RpayData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RpayData(description: $description, image: $image, currency: $currency, key: $key, amount: $amount, name: $name, order_id: $orderId, prefill: $prefill, theme: $theme)';
  }

  @override
  bool operator ==(covariant RpayData other) {
    if (identical(this, other)) return true;

    return other.description == description &&
        other.image == image &&
        other.currency == currency &&
        other.key == key &&
        other.amount == amount &&
        other.name == name &&
        other.orderId == orderId &&
        other.prefill == prefill &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return description.hashCode ^
        image.hashCode ^
        currency.hashCode ^
        key.hashCode ^
        amount.hashCode ^
        name.hashCode ^
        orderId.hashCode ^
        prefill.hashCode ^
        theme.hashCode;
  }
}

class Prefill {
  final String email;
  final String contact;
  final String name;
  Prefill({
    required this.email,
    required this.contact,
    required this.name,
  });

  Prefill copyWith({
    String? email,
    String? contact,
    String? name,
  }) {
    return Prefill(
      email: email ?? this.email,
      contact: contact ?? this.contact,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'contact': contact,
      'name': name,
    };
  }

  factory Prefill.fromMap(Map<String, dynamic> map) {
    return Prefill(
      email: map['email'],
      contact: map['contact'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Prefill.fromJson(String source) =>
      Prefill.fromMap(json.decode(source));

  @override
  String toString() => 'Prefill(email: $email, contact: $contact, name: $name)';

  @override
  bool operator ==(covariant Prefill other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.contact == contact &&
        other.name == name;
  }

  @override
  int get hashCode => email.hashCode ^ contact.hashCode ^ name.hashCode;
}

class Theme {
  final String color;
  Theme({
    required this.color,
  });

  Theme copyWith({
    String? color,
  }) {
    return Theme(
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'color': color,
    };
  }

  factory Theme.fromMap(Map<String, dynamic> map) {
    return Theme(
      color: map['color'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Theme.fromJson(String source) => Theme.fromMap(json.decode(source));

  @override
  String toString() => 'Theme(color: $color)';

  @override
  bool operator ==(covariant Theme other) {
    if (identical(this, other)) return true;

    return other.color == color;
  }

  @override
  int get hashCode => color.hashCode;
}
