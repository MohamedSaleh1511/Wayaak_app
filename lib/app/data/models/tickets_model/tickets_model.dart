import 'datum.dart';

class TicketsModel {
  List<TicketsDatum>? data;
  String? message;
  int? status;

  TicketsModel({this.data, this.message, this.status});

  factory TicketsModel.fromJson(Map<String, dynamic> json) => TicketsModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => TicketsDatum.fromJson(e as Map<String, dynamic>))
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
