import 'package:wayaak/app/data/models/order_details_model/data.dart';

class CurrentShipmentsModel {
  List<OrderDetailsDataa>? data;
  String? message;
  int? status;

  CurrentShipmentsModel({this.data, this.message, this.status});

  factory CurrentShipmentsModel.fromJson(Map<String, dynamic> json) {
    return CurrentShipmentsModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderDetailsDataa.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'message': message,
        'status': status,
      };
}
