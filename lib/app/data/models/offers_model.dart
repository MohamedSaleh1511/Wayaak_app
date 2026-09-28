class Offers {
  int? id;
  int? driverId;
  String? driverName;
  String? rate;
  String? driverAvatar;
  double? price;
  String? latitude;
  String? longitude;

  Offers({
    this.id,
    this.driverAvatar,
    this.driverId,
    this.driverName,
    this.rate,
    this.price,
    this.latitude,
    this.longitude,
  });

  factory Offers.fromJson(Map<String, dynamic> json) => Offers(
        id: json['offer_id'] as int?,
        driverId: json['driver_id'] as int?,
        driverName: json['driver_name'] as String?,
        driverAvatar: json['driver_photo'] as String?,
        rate: json['driver_rate'].toString(),
        price: double.parse(json['price'].toString()),
        latitude: json['latitude'].toString(),
        longitude: json['longitude'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'driver_id': driverId,
        'driver_name': driverName,
        'driver_photo': driverAvatar,
        'rate': rate,
        'price': price,
        'latitude': latitude,
        'longitude': longitude,
      };
}
