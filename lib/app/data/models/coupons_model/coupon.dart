class Coupon {
  int? id;
  String? code;
  String? title;
  String? discountType;
  String? amount;
  dynamic numberOfUse;
  String? userLimit;
  DateTime? startAt;
  DateTime? expiredAt;
  dynamic maxAmount;
  String? firstPurchase;
  String? percentage;

  Coupon({
    this.id,
    this.code,
    this.title,
    this.discountType,
    this.amount,
    this.numberOfUse,
    this.userLimit,
    this.startAt,
    this.expiredAt,
    this.maxAmount,
    this.firstPurchase,
    this.percentage,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json['id'] as int?,
        code: json['code'] as String?,
        title: json['title'] as String?,
        discountType: json['discount_type'] as String?,
        amount: json['amount']?.toString(),
        numberOfUse: json['number_of_use'] as dynamic,
        userLimit: json['user_limit'].toString(),
        startAt: DateTime.parse(json['start_at'].toString()),
        expiredAt: DateTime.parse(json['expired_at'].toString()),
        maxAmount: json['max_amount'] as dynamic,
        firstPurchase: json['first_purchase'] as String?,
        percentage: json['percentage']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title': title,
        'discount_type': discountType,
        'amount': amount,
        'number_of_use': numberOfUse,
        'user_limit': userLimit,
        'start_at': startAt,
        'expired_at': expiredAt,
        'max_amount': maxAmount,
        'first_purchase': firstPurchase,
        'percentage': percentage,
      };
}
