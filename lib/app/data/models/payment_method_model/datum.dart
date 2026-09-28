class PaymentMethodDatum {
  int? id;
  String? name;
  String? link;

  PaymentMethodDatum({this.id, this.name, this.link});

  factory PaymentMethodDatum.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDatum(
        id: json['id'] as int?,
        name: json['name'] as String?,
        link: json['link'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'link': link,
      };
}
