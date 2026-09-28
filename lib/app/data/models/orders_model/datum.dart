import 'package:wayaak/app/core/enums/enums.dart';
import 'package:wayaak/app/data/models/order_details_model/driver.dart';

class OrderDatum {
  int? id;
  String? orderNum;
  String? title;
  String? description;
  String? discountAmount;
  String? discountedPrice;
  String? shippingCost;
  String? totalPrice;
  OrderStatus? orderStatus;
  OrderDetailsDriver? driver;

  OrderDatum({
    this.id,
    this.orderNum,
    this.title,
    this.description,
    this.discountAmount,
    this.discountedPrice,
    this.shippingCost,
    this.totalPrice,
    this.orderStatus,
    this.driver,
  });

  factory OrderDatum.fromJson(Map<String, dynamic> json) => OrderDatum(
        id: json['id'] as int?,
        orderNum: json['order_num'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        discountAmount: json['discount_amount'].toString(),
        discountedPrice: json['discounted_price'].toString(),
        shippingCost: json['shipping_cost'].toString(),
        totalPrice: json['total_price'].toString(),
        orderStatus: OrderStatus.fromJson(json['order_status'] as String),
        driver: json['driver'] == null
            ? null
            : OrderDetailsDriver.fromJson(
                json['driver'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_num': orderNum,
        'title': title,
        'description': description,
        'discount_amount': discountAmount,
        'discounted_price': discountedPrice,
        'shipping_cost': shippingCost,
        'total_price': totalPrice,
        'order_status': orderStatus,
        'driver': driver,
      };
}
