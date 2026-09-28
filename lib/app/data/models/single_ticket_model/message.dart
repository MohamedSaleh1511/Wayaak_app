class Message {
  String? type;
  String? message;
  String? attachment;
  String? createdAt;

  Message({this.type, this.message, this.attachment, this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        type: json['type'] as String?,
        message: json['message'] as String?,
        attachment: json['attachment'] as String?,
        createdAt: json['created_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'message': message,
        'attachment': attachment,
        'created_at': createdAt,
      };
}
