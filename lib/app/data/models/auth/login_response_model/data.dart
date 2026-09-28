import 'user.dart';

class Data {
  User? user;
  String? accessToken;

  Data({this.user, this.accessToken});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        accessToken: json['access_token'] as String?,
      );
}
