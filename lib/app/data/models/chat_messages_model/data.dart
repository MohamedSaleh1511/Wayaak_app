import 'message.dart';
import 'receiver.dart';

class Data {
  int? id;
  Receiver? receiver;
  List<ChatMessage>? messages;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.receiver,
    this.messages,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] as int?,
        receiver: json['receiver'] == null
            ? null
            : Receiver.fromJson(json['receiver'] as Map<String, dynamic>),
        messages: (json['messages'] as List<dynamic>?)
            ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
            .toList(),
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
        'messages': messages?.map((e) => e.toJson()).toList(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
