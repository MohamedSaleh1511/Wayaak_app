import 'sender.dart';

class ChatMessage {
  int? id;
  String? message;
  String? attachment;
  Sender? sender;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatMessage({
    this.id,
    this.message,
    this.attachment,
    this.sender,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as int?,
        message: json['message'] as String?,
        attachment: json['attachment'] as String?,
        sender: json['sender'] == null
            ? null
            : Sender.fromJson(json['sender'] as Map<String, dynamic>),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'attachment': attachment,
        'sender': sender?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
