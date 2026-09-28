import 'order.dart';

class Data {
  Order? order;

  Data({this.order});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        order: json['order'] == null
            ? null
            : Order.fromJson(json['order'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'order': order?.toJson(),
      };
}
