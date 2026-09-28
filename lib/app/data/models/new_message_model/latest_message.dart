class LatestMessage {
  int? id;
  String? message;
  String? attachment;
  DateTime? createdAt;
  DateTime? updatedAt;

  LatestMessage({
    this.id,
    this.message,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

  factory LatestMessage.fromJson(Map<String, dynamic> json) => LatestMessage(
        id: json['id'] as int?,
        message: json['message'] as String?,
        attachment: json['attachment'] as String?,
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
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
