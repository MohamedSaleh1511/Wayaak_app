import 'data.dart';

class LoginResponseModel {
  Data? data;
  String? message;
  int? status;

  LoginResponseModel({this.data, this.message, this.status});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }
}
