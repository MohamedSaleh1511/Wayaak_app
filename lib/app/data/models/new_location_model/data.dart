class Data {
  String? title;
  String? latitude;
  String? longitude;

  Data({this.title, this.latitude, this.longitude});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json['title'] as String?,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'latitude': latitude,
        'longitude': longitude,
      };
}
