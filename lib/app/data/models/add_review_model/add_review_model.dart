import 'data.dart';

class AddReviewModel {
  Data? data;
  String? message;
  int? status;

  AddReviewModel({this.data, this.message, this.status});

  factory AddReviewModel.fromJson(Map<String, dynamic> json) {
    return AddReviewModel(
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
