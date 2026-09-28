import 'coupon.dart';

class Data {
  List<Coupon>? coupons;

  Data({this.coupons});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        coupons: (json['coupons'] as List<dynamic>?)
            ?.map((e) => Coupon.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'coupons': coupons?.map((e) => e.toJson()).toList(),
      };
}
