import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class SearchModel {
  final String value;
  final int id;
  final String type;
  final int parentId;

  static final helper = HelperModel(SearchModel.fromMap);

  SearchModel({
    required this.value,
    required this.id,
    required this.type,
    this.parentId = 0,
  });

  SearchModel copyWith({
    String? value,
    int? id,
    String? type,
    int? parentId,
  }) {
    return SearchModel(
      value: value ?? this.value,
      id: id ?? this.id,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'id': id,
      'type': type,
      'parent_id': parentId,
    };
  }

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      value: map['value'] as String,
      id: map['id'].toInt() as int,
      type: map['type'] as String,
      parentId: map['parent_id'] == null ? 0 : map['parent_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchModel.fromJson(String source) =>
      SearchModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SearchModel(value: $value, id: $id, type: $type, parentId: $parentId)';

  @override
  bool operator ==(covariant SearchModel other) {
    if (identical(this, other)) return true;

    return other.value == value &&
        other.id == id &&
        other.type == type &&
        other.parentId == parentId;
  }

  @override
  int get hashCode =>
      value.hashCode ^ id.hashCode ^ type.hashCode ^ parentId.hashCode;
}
