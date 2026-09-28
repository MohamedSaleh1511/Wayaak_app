import 'data.dart';

class ContactUsModel {
  Data? data;
  String? message;
  int? status;

  ContactUsModel({this.data, this.message, this.status});

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(
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
