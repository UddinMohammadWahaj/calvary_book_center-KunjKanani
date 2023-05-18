import 'dart:convert';

import 'package:bookcenter/util/helper_model.dart';
import 'package:flutter/foundation.dart';

class BookModel {
  final int id;
  final String? author;
  final String bookTitle;
  final String? bookTeluguTitle;
  final String? book;
  final String? bookSlider;
  final Language? language;
  final String? bookLogo;
  final String? demoBook;
  final String? price;
  final String? description;
  final List<String>? bookTags;
  String? paymentStatus;
  bool isDownloaded;
  static final helper = HelperModel((map) => BookModel.fromMap(map));

  BookModel({
    required this.id,
    this.author,
    required this.bookTitle,
    this.bookTeluguTitle,
    this.book,
    this.bookSlider,
    this.language,
    this.bookLogo,
    this.demoBook,
    this.price,
    this.paymentStatus,
    this.description,
    this.bookTags,
    this.isDownloaded = false,
  });

  BookModel copyWith({
    int? id,
    String? author,
    String? bookTitle,
    String? bookTeluguTitle,
    String? book,
    String? bookSlider,
    Language? language,
    String? bookLogo,
    String? demoBook,
    String? price,
    String? paymentStatus,
    String? description,
    List<String>? bookTags,
    bool? isDownloaded,
  }) {
    return BookModel(
      id: id ?? this.id,
      author: author ?? this.author,
      bookTitle: bookTitle ?? this.bookTitle,
      bookTeluguTitle: bookTeluguTitle ?? this.bookTeluguTitle,
      book: book ?? this.book,
      bookSlider: bookSlider ?? this.bookSlider,
      language: language ?? this.language,
      bookLogo: bookLogo ?? this.bookLogo,
      demoBook: demoBook ?? this.demoBook,
      price: price ?? this.price,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      description: description ?? this.description,
      bookTags: bookTags ?? this.bookTags,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'author': author,
      'book_title': bookTitle,
      'book_telugu_title': bookTeluguTitle,
      'book': book,
      'book_slider': bookSlider,
      'language': language!.toMap(),
      'book_logo': bookLogo,
      'demo_book': demoBook,
      'price': price,
      'payment_status': paymentStatus,
      'description': description,
      'tags': bookTags,
      'is_downloaded': isDownloaded,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? 0,
      author: map['author'] ?? '',
      bookTitle: map['book_title'] ?? '',
      bookTeluguTitle: map['book_telugu_title'] ?? '',
      book: map['book'] ?? '',
      bookSlider: map['book_slider'] ?? '',
      language: Language.fromMap(map['language'] ?? {}),
      bookLogo: map['book_logo'] ?? '',
      demoBook: map['demo_book'] ?? '',
      price: map['price'] ?? '',
      paymentStatus: map['payment_status'] ?? '',
      description: map['description'] ?? '',
      bookTags: List<String>.from(map['tags'] ?? []),
      isDownloaded: map['is_downloaded'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) =>
      BookModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookModel(id: $id, author: $author, book_title: $bookTitle, book_telugu_title: $bookTeluguTitle, book: $book, book_slider: $bookSlider, language: $language, book_logo: $bookLogo, demo_book: $demoBook, price: $price, payment_status: $paymentStatus, description: $description, tags: $bookTags, is_downloaded: $isDownloaded)';
  }

  @override
  bool operator ==(covariant BookModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.author == author &&
        other.bookTitle == bookTitle &&
        other.bookTeluguTitle == bookTeluguTitle &&
        other.book == book &&
        other.bookSlider == bookSlider &&
        other.language == language &&
        other.bookLogo == bookLogo &&
        other.demoBook == demoBook &&
        other.price == price &&
        other.paymentStatus == paymentStatus &&
        other.description == description &&
        listEquals(other.bookTags, bookTags) &&
        other.isDownloaded == isDownloaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        author.hashCode ^
        bookTitle.hashCode ^
        bookTeluguTitle.hashCode ^
        book.hashCode ^
        bookSlider.hashCode ^
        language.hashCode ^
        bookLogo.hashCode ^
        demoBook.hashCode ^
        price.hashCode ^
        paymentStatus.hashCode ^
        description.hashCode ^
        bookTags.hashCode ^
        isDownloaded.hashCode;
  }
}

class Language {
  final int id;
  final String languageIcon;
  final String languageTitle;
  Language({
    required this.id,
    required this.languageIcon,
    required this.languageTitle,
  });

  Language copyWith({
    int? id,
    String? languageIcon,
    String? languageTitle,
  }) {
    return Language(
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

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      id: map['id'] ?? 0,
      languageIcon: map['language_icon'] ?? '',
      languageTitle: map['language_title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Language.fromJson(String source) =>
      Language.fromMap(json.decode(source));

  @override
  String toString() =>
      'Language(id: $id, language_icon: $languageIcon, language_title: $languageTitle)';

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.languageIcon == languageIcon &&
        other.languageTitle == languageTitle;
  }

  @override
  int get hashCode =>
      id.hashCode ^ languageIcon.hashCode ^ languageTitle.hashCode;
}
