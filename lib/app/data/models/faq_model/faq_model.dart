import 'data.dart';

class FaqModel {
  Data? data;
  String? message;
  int? status;

  FaqModel({this.data, this.message, this.status});

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
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
