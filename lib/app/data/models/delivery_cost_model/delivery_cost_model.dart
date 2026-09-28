import 'data.dart';

class DeliveryCostModel {
  Data? data;
  String? message;
  int? status;

  DeliveryCostModel({this.data, this.message, this.status});

  factory DeliveryCostModel.fromJson(Map<String, dynamic> json) {
    return DeliveryCostModel(
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
