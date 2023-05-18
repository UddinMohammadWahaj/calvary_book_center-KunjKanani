import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';

class LanguageModel {
  final int id;
  final String? languageIcon;
  final String? languageTitle;

  static final helper = HelperModel(
    (map) => LanguageModel.fromMap(map),
  );

  LanguageModel({
    required this.id,
    required this.languageIcon,
    required this.languageTitle,
  });

  LanguageModel copyWith({
    int? id,
    String? languageIcon,
    String? languageTitle,
  }) {
    return LanguageModel(
      id: id ?? this.id,
      languageIcon: languageIcon ?? this.languageIcon,
      languageTitle: languageTitle ?? this.languageTitle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'language_icon': languageIcon,
      'language_title': languageTitle,
    };
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      id: map['id'] ?? 0,
      languageIcon: map['language_icon'] ?? '',
      languageTitle: map['language_title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromJson(String source) =>
      LanguageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LanguageModel(id: $id, language_icon: $languageIcon, language_title: $languageTitle)';

  @override
  bool operator ==(covariant LanguageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.languageIcon == languageIcon &&
        other.languageTitle == languageTitle;
  }

  @override
  int get hashCode =>
      id.hashCode ^ languageIcon.hashCode ^ languageTitle.hashCode;
}
