import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/models/chat_messages_model/message.dart';

class Messages {
  MesssageStatus? status;
  bool? isAttachmentPath;
  ChatMessage? message;

  Messages({this.status, this.message, this.isAttachmentPath});

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        status: json['status'] as MesssageStatus?,
        isAttachmentPath: json['isAttachmentPath'] as bool?,
        message: json['message'] == null
            ? null
            : ChatMessage.fromJson(json['message'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'isAttachmentPath': isAttachmentPath,
      };
}
