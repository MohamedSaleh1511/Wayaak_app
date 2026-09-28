import 'current_location.dart';
import 'destination_location.dart';
import 'driver.dart';
import 'product_image.dart';
import 'user.dart';

class Order {
  int? id;
  String? orderNum;
  String? title;
  String? description;
  int? discountAmount;
  int? discountedPrice;
  int? shippingCost;
  int? totalPrice;
  String? orderStatus;
  User? user;
  Driver? driver;
  List<ProductImage>? productImages;
  CurrentLocation? currentLocation;
  DestinationLocation? destinationLocation;

  Order({
    this.id,
    this.orderNum,
    this.title,
    this.description,
    this.discountAmount,
    this.discountedPrice,
    this.shippingCost,
    this.totalPrice,
    this.orderStatus,
    this.user,
    this.driver,
    this.productImages,
    this.currentLocation,
    this.destinationLocation,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as int?,
        orderNum: json['order_num'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        discountAmount: json['discount_amount'] as int?,
        discountedPrice: json['discounted_price'] as int?,
        shippingCost: json['shipping_cost'] as int?,
        totalPrice: json['total_price'] as int?,
        orderStatus: json['order_status'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        driver: json['driver'] == null
            ? null
            : Driver.fromJson(json['driver'] as Map<String, dynamic>),
        productImages: (json['product_images'] as List<dynamic>?)
            ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        currentLocation: json['current_location'] == null
            ? null
            : CurrentLocation.fromJson(
                json['current_location'] as Map<String, dynamic>),
        destinationLocation: json['destination_location'] == null
            ? null
            : DestinationLocation.fromJson(
                json['destination_location'] as Map<String, dynamic>),
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
        'user': user?.toJson(),
        'driver': driver?.toJson(),
        'product_images': productImages?.map((e) => e.toJson()).toList(),
        'current_location': currentLocation?.toJson(),
        'destination_location': destinationLocation?.toJson(),
      };
}
