import 'message.dart';

class Data {
  int? id;
  String? ticketNum;
  String? subject;
  String? status;
  DateTime? createdAt;
  String? lastUpdateAt;
  List<TicketMessage>? messages;

  Data({
    this.id,
    this.ticketNum,
    this.subject,
    this.status,
    this.createdAt,
    this.lastUpdateAt,
    this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] as int?,
        ticketNum: json['ticket_num'] as String?,
        subject: json['subject'] as String?,
        status: json['status'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        lastUpdateAt: json['last_update_at'] as String?,
        messages: (json['messages'] as List<dynamic>?)
            ?.map((e) => TicketMessage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ticket_num': ticketNum,
        'subject': subject,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'last_update_at': lastUpdateAt,
        'messages': messages?.map((e) => e.toJson()).toList(),
      };
}
