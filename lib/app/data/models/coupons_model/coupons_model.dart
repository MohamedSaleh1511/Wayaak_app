import 'data.dart';

class CouponsModel {
  Data? data;
  String? message;
  int? status;

  CouponsModel({this.data, this.message, this.status});

  factory CouponsModel.fromJson(Map<String, dynamic> json) => CouponsModel(
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
