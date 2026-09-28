class Data {
  String? driver;
  String? comment;
  String? rate;

  Data({this.driver, this.comment, this.rate});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        driver: json['driver'] as String?,
        comment: json['comment'] as String?,
        rate: json['rate'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'driver': driver,
        'comment': comment,
        'rate': rate,
      };
}
