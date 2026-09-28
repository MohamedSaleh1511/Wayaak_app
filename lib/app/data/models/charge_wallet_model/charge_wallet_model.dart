import 'data.dart';

class ChargeWalletModel {
  Data? data;
  String? message;
  int? status;

  ChargeWalletModel({this.data, this.message, this.status});

  factory ChargeWalletModel.fromJson(Map<String, dynamic> json) {
    return ChargeWalletModel(
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
