import 'data.dart';

class ReviewsModel {
  Data? data;
  String? message;
  int? status;

  ReviewsModel({this.data, this.message, this.status});

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
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
