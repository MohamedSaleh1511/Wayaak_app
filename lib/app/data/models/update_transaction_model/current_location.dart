class CurrentLocation {
  int? id;
  String? title;
  String? latitude;
  String? longitude;

  CurrentLocation({this.id, this.title, this.latitude, this.longitude});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
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
