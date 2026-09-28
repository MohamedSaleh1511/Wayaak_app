class TicketMessage {
  String? type;
  String? message;
  String? attachment;
  bool? isPath;
  DateTime? createdAt;

  TicketMessage(
      {this.type,
      this.message,
      this.attachment,
      this.createdAt,
      this.isPath = false});

  factory TicketMessage.fromJson(Map<String, dynamic> json) => TicketMessage(
        type: json['type'] as String?,
        message: json['message'] as String?,
        attachment: json['attachment'] as String?,
        createdAt: DateTime.parse(json['created_at'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'message': message,
        'attachment': attachment,
        'created_at': createdAt,
      };
}
