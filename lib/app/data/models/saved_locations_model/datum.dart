class LocationDatum {
  int? id;
  String? title;
  String? latitude;
  String? longitude;

  LocationDatum({this.id, this.title, this.latitude, this.longitude});

  factory LocationDatum.fromJson(Map<String, dynamic> json) => LocationDatum(
        id: json['id'] as int?,
        title: json['title'] as String?,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'int': int,
        'title': title,
        'latitude': latitude,
        'longitude': longitude,
      };
}
