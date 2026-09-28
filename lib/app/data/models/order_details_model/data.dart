import 'package:wayaak/app/core/enums/enums.dart';

import 'current_location.dart';
import 'destination_location.dart';
import 'driver.dart';
import 'product_image.dart';
import 'user.dart';
import 'vehicle_category.dart';

class OrderDetailsDataa {
  int? id;
  VehicleCategory? vehicleCategory;
  String? orderNum;
  String? title;
  String? description;
  String? discountAmount;
  String? discountedPrice;
  String? shippingCost;
  String? totalPrice;
  OrderStatus? orderStatus;
  String? urgent;
  User? user;
  OrderDetailsDriver? driver;
  List<ProductImage>? productImages;
  String? country;
  CurrentLocation? currentLocation;
  DestinationLocation? destinationLocation;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderDetailsDataa({
    this.id,
    this.vehicleCategory,
    this.orderNum,
    this.title,
    this.description,
    this.discountAmount,
    this.discountedPrice,
    this.shippingCost,
    this.totalPrice,
    this.orderStatus,
    this.urgent,
    this.user,
    this.driver,
    this.productImages,
    this.country,
    this.currentLocation,
    this.destinationLocation,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderDetailsDataa.fromJson(Map<String, dynamic> json) =>
      OrderDetailsDataa(
        id: json['id'] as int?,
        vehicleCategory: json['vehicle_category'] == null
            ? null
            : VehicleCategory.fromJson(
                json['vehicle_category'] as Map<String, dynamic>),
        orderNum: json['order_num'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        discountAmount: json['discount_amount'].toString(),
        discountedPrice: json['discounted_price'].toString(),
        shippingCost: json['shipping_cost'].toString(),
        totalPrice: json['total_price'].toString(),
        orderStatus: OrderStatus.fromJson(json['order_status'].toString()),
        urgent: json['urgent'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        driver: json['driver'] == null
            ? null
            : OrderDetailsDriver.fromJson(
                json['driver'] as Map<String, dynamic>),
        productImages: (json['product_images'] as List<dynamic>?)
            ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        country: json['country'] as String?,
        currentLocation: json['current_location'] == null
            ? null
            : CurrentLocation.fromJson(
                json['current_location'] as Map<String, dynamic>),
        destinationLocation: json['destination_location'] == null
            ? null
            : DestinationLocation.fromJson(
                json['destination_location'] as Map<String, dynamic>),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicle_category': vehicleCategory?.toJson(),
        'order_num': orderNum,
        'title': title,
        'description': description,
        'discount_amount': discountAmount,
        'discounted_price': discountedPrice,
        'shipping_cost': shippingCost,
        'total_price': totalPrice,
        'order_status': orderStatus,
        'urgent': urgent,
        'user': user?.toJson(),
        'driver': driver?.toJson(),
        'product_images': productImages?.map((e) => e.toJson()).toList(),
        'country': country,
        'current_location': currentLocation?.toJson(),
        'destination_location': destinationLocation?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
