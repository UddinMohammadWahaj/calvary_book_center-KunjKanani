import 'dart:convert';

class UserModel {
  final bool? isSuccess;
  final String? token;
  final int? userId;
  final String? name;
  final String? mobile;
  final String? email;
  UserModel({
    this.isSuccess,
    this.token,
    this.userId,
    this.name,
    this.mobile,
    this.email,
  });

  UserModel copyWith({
    bool? isSuccess,
    String? token,
    int? userId,
    String? name,
    String? mobile,
    String? email,
  }) {
    return UserModel(
      isSuccess: isSuccess ?? this.isSuccess,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'is_success': isSuccess,
      'token': token,
      'user_id': userId,
      'name': name,
      'mobile': mobile,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      isSuccess: map['is_success'] ?? false,
      token: map['token'] ?? '',
      userId: map['id'] ?? 0,
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(is_success: $isSuccess, token: $token, user_id: $userId, name: $name, mobile: $mobile, email: $email)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.isSuccess == isSuccess &&
        other.token == token &&
        other.userId == userId &&
        other.name == name &&
        other.mobile == mobile &&
        other.email == email;
  }

  @override
  int get hashCode {
    return isSuccess.hashCode ^
        token.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        mobile.hashCode ^
        email.hashCode;
  }
}
