import 'data.dart';

class NewMessageModel {
  Data? data;
  String? message;
  int? status;

  NewMessageModel({this.data, this.message, this.status});

  factory NewMessageModel.fromJson(Map<String, dynamic> json) {
    return NewMessageModel(
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
