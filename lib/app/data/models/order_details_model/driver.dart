import 'vehicle.dart';

class OrderDetailsDriver {
  int? id;
  String? name;
  String? phone;
  String? driverPhoto;
  String? rate;
  String? latitude;
  String? longitude;
  OrderDetailsVehicle? vehicle;

  OrderDetailsDriver({
    this.id,
    this.name,
    this.phone,
    this.driverPhoto,
    this.rate,
    this.latitude,
    this.longitude,
    this.vehicle,
  });

  factory OrderDetailsDriver.fromJson(Map<String, dynamic> json) =>
      OrderDetailsDriver(
        id: json['id'] as int?,
        name: json['name'] as String?,
        phone: json['phone'] as String?,
        driverPhoto: json['driver_photo'] as String?,
        rate: json['rate'] as String?,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
        vehicle: json['vehicle'] == null
            ? null
            : OrderDetailsVehicle.fromJson(
                json['vehicle'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'driver_photo': driverPhoto,
        'rate': rate,
        'latitude': latitude,
        'longitude': longitude,
        'vehicle': vehicle?.toJson(),
      };
}
