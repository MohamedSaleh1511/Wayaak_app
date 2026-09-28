import 'datum.dart';

class BannersModel {
  List<BannerData>? data;
  String? message;
  int? status;

  BannersModel({this.data, this.message, this.status});

  factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => BannerData.fromJson(e as Map<String, dynamic>))
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
