import 'data.dart';

class BalanceModel {
  Data? data;
  String? message;
  int? status;

  BalanceModel({this.data, this.message, this.status});

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
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
