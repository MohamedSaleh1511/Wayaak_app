import 'data.dart';

class NotificationsModel {
  Data? data;
  String? message;
  int? status;

  NotificationsModel({this.data, this.message, this.status});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
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
