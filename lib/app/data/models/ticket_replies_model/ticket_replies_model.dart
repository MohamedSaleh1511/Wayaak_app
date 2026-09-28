import 'data.dart';

class TicketRepliesModel {
  Data? data;
  String? message;
  int? status;

  TicketRepliesModel({this.data, this.message, this.status});

  factory TicketRepliesModel.fromJson(Map<String, dynamic> json) {
    return TicketRepliesModel(
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
