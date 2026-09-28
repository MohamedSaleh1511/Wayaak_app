import 'datum.dart';

class OffersModel {
  List<OffersDatum>? data;
  String? message;
  int? status;

  OffersModel({this.data, this.message, this.status});

  factory OffersModel.fromJson(Map<String, dynamic> json) => OffersModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => OffersDatum.fromJson(e as Map<String, dynamic>))
            .toList(),
        message: json['message'] as String?,
        status: json['status'] as int?,
      );

  // Map<String, dynamic> toJson() => {
  //       'data': data?.map((e) => e.toJson()).toList(),
  //       'message': message,
  //       'status': status,
  //     };
}
