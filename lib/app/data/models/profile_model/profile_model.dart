import 'data.dart';

class ProfileModel {
  Data? data;
  String? message;
  int? status;

  ProfileModel({this.data, this.message, this.status});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
        message: json['message'] as String?,
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'message': message,
        'status': status,
      };
}
