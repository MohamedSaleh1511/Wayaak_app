import 'datum.dart';

class AllChatsModel {
  List<ChatsDatum>? data;
  String? message;
  int? status;

  AllChatsModel({this.data, this.message, this.status});

  factory AllChatsModel.fromJson(Map<String, dynamic> json) => AllChatsModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => ChatsDatum.fromJson(e as Map<String, dynamic>))
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
