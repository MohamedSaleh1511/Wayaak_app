import 'data.dart';

class StaticPagesModel {
  Data? data;
  String? message;
  int? status;

  StaticPagesModel({this.data, this.message, this.status});

  factory StaticPagesModel.fromJson(Map<String, dynamic> json) {
    return StaticPagesModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'message': message,
        'status': status,
      };
}
