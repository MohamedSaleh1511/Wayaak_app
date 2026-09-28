import 'data.dart';

class AddOrderModel {
  Data? data;
  String? message;
  int? status;

  AddOrderModel({this.data, this.message, this.status});

  factory AddOrderModel.fromJson(Map<String, dynamic> json) => AddOrderModel(
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
