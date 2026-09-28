import 'datum.dart';

class OrdersModel {
  List<OrderDatum>? data;
  String? message;
  int? status;

  OrdersModel({this.data, this.message, this.status});

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => OrderDatum.fromJson(e as Map<String, dynamic>))
            .toList(),
        message: json['message'] as String?,
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'message': message,
        'status': status,
      };
}
