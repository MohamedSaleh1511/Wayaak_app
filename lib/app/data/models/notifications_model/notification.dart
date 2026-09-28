import 'message.dart';

class NotificationData {
  String? id;
  Message? message;
  String? url;
  String? type;
  String? orderNum;
  int? orderId;
  dynamic senderId;
  int? driverId;
  String? ticketNum;
  String? payment;
  String? randomNumber;
  String? totalPrice;
  String? readAt;
  String? paymentUrl;
  DateTime? createdAt;

  NotificationData({
    this.id,
    this.message,
    this.url,
    this.type,
    this.orderNum,
    this.orderId,
    this.senderId,
    this.readAt,
    this.createdAt,
    this.driverId,
    this.ticketNum,
    this.payment,
    this.randomNumber,
    this.totalPrice,
    this.paymentUrl,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json['id'] as String?,
        message: json['message'] == null
            ? null
            : Message.fromJson(json['message'] as Map<String, dynamic>),
        url: json['url'] as String?,
        type: json['type'] as String?,
        orderNum: json['order_num'] as String?,
        orderId: json['order_id'] as int?,
        senderId: json['sender_id'] as dynamic,
        driverId: json['driver_id'] as int?,
        ticketNum: json['ticket_num'] as String?,
        payment: json['payment'] as String?,
        randomNumber: json['randomNumber'].toString(),
        totalPrice: json['total_price'].toString(),
        readAt: json['read_at'] as String?,
        paymentUrl: json['payment_url'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message?.toJson(),
        'url': url,
        'type': type,
        'order_num': orderNum,
        'order_id': orderId,
        'sender_id': senderId,
        'driver_id': driverId,
        'payment': payment,
        'read_at': readAt,
        'payment_url': paymentUrl,
        'created_at': createdAt?.toIso8601String(),
      };
}
