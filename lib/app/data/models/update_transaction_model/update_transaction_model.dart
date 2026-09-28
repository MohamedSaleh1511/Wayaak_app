import 'data.dart';

class UpdateTransactionModel {
  Data? data;
  String? message;
  int? status;

  UpdateTransactionModel({this.data, this.message, this.status});

  factory UpdateTransactionModel.fromJson(Map<String, dynamic> json) {
    return UpdateTransactionModel(
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
