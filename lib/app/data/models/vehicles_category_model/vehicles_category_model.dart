import 'datum.dart';

class VehiclesCategoryModel {
  List<VehiclesDatum>? data;
  String? message;
  int? status;

  VehiclesCategoryModel({this.data, this.message, this.status});

  factory VehiclesCategoryModel.fromJson(Map<String, dynamic> json) {
    return VehiclesCategoryModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => VehiclesDatum.fromJson(e as Map<String, dynamic>))
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
