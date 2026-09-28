class CountryDatum {
  int? id;
  String? name;
  String? code;

  CountryDatum({this.id, this.name, this.code});

  factory CountryDatum.fromJson(Map<String, dynamic> json) => CountryDatum(
        id: json['id'] as int?,
        name: json['name'] as String?,
        code: json['code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}
