import 'datum.dart';

class PaymentMethodModel {
  List<PaymentMethodDatum>? data;
  String? message;
  int? status;

  PaymentMethodModel({this.data, this.message, this.status});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PaymentMethodDatum.fromJson(e as Map<String, dynamic>))
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
