class OffersDatum {
  int? id;
  DriverOffer? driver;
  double? price;

  OffersDatum({
    this.id,
    this.driver,
    this.price,
  });

  factory OffersDatum.fromJson(Map<String, dynamic> json) => OffersDatum(
        id: json['id'] as int?,
        price: double.parse(json['offer_price'].toString()),
        driver: json['driver'] == null
            ? null
            : DriverOffer.fromJson(json['driver'] as Map<String, dynamic>),
      );
}

class DriverOffer {
  int? id;
  String? driverName;
  String? driverPhoto;
  String? rate;
  String? latitude;
  String? longitude;

  DriverOffer({
    this.id,
    this.driverName,
    this.rate,
    this.latitude,
    this.longitude,
    this.driverPhoto,
  });

  factory DriverOffer.fromJson(Map<String, dynamic> json) => DriverOffer(
        id: json['id'] as int?,
        driverName: json['name'].toString(),
        driverPhoto: json['driver_photo'].toString(),
        rate: json['rate'].toString(),
        latitude: json['latitude'].toString(),
        longitude: json['longitude'].toString(),
      );
}
