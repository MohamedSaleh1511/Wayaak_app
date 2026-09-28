import 'data.dart';

class OrderDetailsModel {
  OrderDetailsDataa? data;
  String? message;
  int? status;

  OrderDetailsModel({this.data, this.message, this.status});

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      data: json['data'] == null
          ? null
          : OrderDetailsDataa.fromJson(json['data'] as Map<String, dynamic>),
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
