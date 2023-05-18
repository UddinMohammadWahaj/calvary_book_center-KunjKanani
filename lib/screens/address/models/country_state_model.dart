import 'dart:convert';

import 'package:flutter/foundation.dart';

class CountryStateModel {
  final List<Country> countries;
  CountryStateModel({
    this.countries = const [],
  });

  CountryStateModel copyWith({
    List<Country>? countries,
  }) {
    return CountryStateModel(
      countries: countries ?? this.countries,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'countries': countries.map((x) => x.toMap()).toList(),
    };
  }

  factory CountryStateModel.fromMap(Map<String, dynamic> map) {
    return CountryStateModel(
      countries: List<Country>.from(
        (map['countries']).map<Country>(
          (x) => Country.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryStateModel.fromJson(String source) =>
      CountryStateModel.fromMap(json.decode(source));

  @override
  String toString() => 'CountryStateModel(countries: $countries)';

  @override
  bool operator ==(covariant CountryStateModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.countries, countries);
  }

  @override
  int get hashCode => countries.hashCode;
}

class Country {
  final int id;
  final String country;
  final List<State> states;
  Country({
    required this.id,
    required this.country,
    required this.states,
  });

  Country copyWith({
    int? id,
    String? country,
    List<State>? states,
  }) {
    return Country(
      id: id ?? this.id,
      country: country ?? this.country,
      states: states ?? this.states,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'country': country,
      'states': states.map((x) => x.toMap()).toList(),
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'] ?? 0,
      country: map['country'] ?? '',
      states: List<State>.from(
        (map['states']).map<State>(
          (x) => State.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source));

  @override
  String toString() => 'Countrie(id: $id, country: $country, states: $states)';

  @override
  bool operator ==(covariant Country other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.country == country &&
        listEquals(other.states, states);
  }

  @override
  int get hashCode => id.hashCode ^ country.hashCode ^ states.hashCode;
}

class State {
  final int id;
  final String state;
  final List<City> cities;
  State({
    required this.id,
    required this.state,
    required this.cities,
  });

  State copyWith({
    int? id,
    String? state,
    List<City>? cities,
  }) {
    return State(
      id: id ?? this.id,
      state: state ?? this.state,
      cities: cities ?? this.cities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'state': state,
      'cities': cities.map((x) => x.toMap()).toList(),
    };
  }

  factory State.fromMap(Map<String, dynamic> map) {
    return State(
      id: map['id'] ?? 0,
      state: map['state'] ?? '',
      cities: List<City>.from(
        (map['cities']).map<City>(
          (x) => City.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory State.fromJson(String source) => State.fromMap(json.decode(source));

  @override
  String toString() => 'State(id: $id, state: $state, cities: $cities)';

  @override
  bool operator ==(covariant State other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.state == state &&
        listEquals(other.cities, cities);
  }

  @override
  int get hashCode => id.hashCode ^ state.hashCode ^ cities.hashCode;
}

class City {
  final int id;
  final String city;
  final List<PinCode> pinCodes;
  City({
    required this.id,
    required this.city,
    required this.pinCodes,
  });

  City copyWith({
    int? id,
    String? city,
    List<PinCode>? pinCodes,
  }) {
    return City(
      id: id ?? this.id,
      city: city ?? this.city,
      pinCodes: pinCodes ?? this.pinCodes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'city': city,
      'pin_codes': pinCodes.map((x) => x.toMap()).toList(),
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] ?? 0,
      city: map['city'] ?? '',
      pinCodes: List<PinCode>.from(
        (map['pin_codes']).map<PinCode>(
          (x) => PinCode.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) => City.fromMap(json.decode(source));

  @override
  String toString() => 'Citie(id: $id, city: $city, pin_codes: $pinCodes)';

  @override
  bool operator ==(covariant City other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.city == city &&
        listEquals(other.pinCodes, pinCodes);
  }

  @override
  int get hashCode => id.hashCode ^ city.hashCode ^ pinCodes.hashCode;
}

class PinCode {
  final int id;
  final String name;
  PinCode({
    required this.id,
    required this.name,
  });

  PinCode copyWith({
    int? id,
    String? name,
  }) {
    return PinCode(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory PinCode.fromMap(Map<String, dynamic> map) {
    return PinCode(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PinCode.fromJson(String source) =>
      PinCode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PinCode(id: $id, name: $name)';

  @override
  bool operator ==(covariant PinCode other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
