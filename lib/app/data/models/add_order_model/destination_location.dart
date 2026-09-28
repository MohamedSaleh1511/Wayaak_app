class DestinationLocation {
  int? id;
  String? title;
  String? latitude;
  String? longitude;

  DestinationLocation({this.id, this.title, this.latitude, this.longitude});

  factory DestinationLocation.fromJson(Map<String, dynamic> json) {
    return DestinationLocation(
      id: json['id'] as int?,
      title: json['title'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'latitude': latitude,
        'longitude': longitude,
      };
}
