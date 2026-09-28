import 'latest_message.dart';
import 'receiver.dart';

class Data {
  int? id;
  Receiver? receiver;
  LatestMessage? latestMessage;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.receiver,
    this.latestMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] as int?,
        receiver: json['receiver'] == null
            ? null
            : Receiver.fromJson(json['receiver'] as Map<String, dynamic>),
        latestMessage: json['latest_message'] == null
            ? null
            : LatestMessage.fromJson(
                json['latest_message'] as Map<String, dynamic>),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'receiver': receiver?.toJson(),
        'latest_message': latestMessage?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
