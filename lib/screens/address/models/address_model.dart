import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class AddressModel {
  final int? id;
  final String? name;
  final String? mobile;
  final String? address;
  final String? address2;
  final String? landmark;
  final int? user;
  final int? country;
  final int? state;
  final int? city;
  final int? pinCode;

  static final helper = HelperModel<AddressModel>(
    (map) => AddressModel.fromMap(map),
  );

  AddressModel({
    this.id,
    this.name,
    this.mobile,
    this.address,
    this.address2,
    this.landmark,
    this.user,
    this.country,
    this.state,
    this.city,
    this.pinCode,
  });

  AddressModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? address,
    String? address2,
    String? landmark,
    int? user,
    int? country,
    int? state,
    int? city,
    int? pinCode,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      address2: address2 ?? this.address2,
      landmark: landmark ?? this.landmark,
      user: user ?? this.user,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      pinCode: pinCode ?? this.pinCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'mobile': mobile,
      'address': address,
      'address2': address2,
      'landmark': landmark,
      'user': user,
      'country': country,
      'state': state,
      'city': city,
      'pin_code': pinCode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      address: map['address'] ?? '',
      address2: map['address2'] ?? '',
      landmark: map['landmark'] ?? '',
      user: map['user'] ?? 0,
      country: map['country'],
      state: map['state'],
      city: map['city'],
      pinCode: map['pin_code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(id: $id, name: $name, mobile: $mobile, address: $address, address2: $address2, landmark: $landmark, user: $user, country: $country, state: $state, city: $city, pin_code: $pinCode)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.mobile == mobile &&
        other.address == address &&
        other.address2 == address2 &&
        other.landmark == landmark &&
        other.user == user &&
        other.country == country &&
        other.state == state &&
        other.city == city &&
        other.pinCode == pinCode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        mobile.hashCode ^
        address.hashCode ^
        address2.hashCode ^
        landmark.hashCode ^
        user.hashCode ^
        country.hashCode ^
        state.hashCode ^
        city.hashCode ^
        pinCode.hashCode;
  }
}
