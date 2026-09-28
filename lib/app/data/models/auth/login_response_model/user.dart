import 'package:wayaak/app/core/enums/enums.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? birthDate;
  String? language;
  dynamic avatar;
  UserType? type;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.language,
    this.avatar,
    this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        gender: json['gender'] as String?,
        birthDate: json['birth_date'] as String?,
        language: json['language'] as String?,
        avatar: json['avatar'] as dynamic,
        type: UserType.fromJson(json['type']),
      );
}
