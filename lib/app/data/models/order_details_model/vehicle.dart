import 'type.dart';
import 'vehicle_category.dart';

class OrderDetailsVehicle {
  VehicleCategory? category;
  VehicleType? type;
  String? vehiclePhoto;
  String? frontLicense;
  String? backLicense;
  String? vehicleMetalPlate;
  String? vehicleManufactureYear;
  String? licenseExpiryDate;
  int? confirmDocuments;

  OrderDetailsVehicle({
    this.category,
    this.type,
    this.vehiclePhoto,
    this.frontLicense,
    this.backLicense,
    this.vehicleMetalPlate,
    this.vehicleManufactureYear,
    this.licenseExpiryDate,
    this.confirmDocuments,
  });

  factory OrderDetailsVehicle.fromJson(Map<String, dynamic> json) =>
      OrderDetailsVehicle(
        category: json['category'] == null
            ? null
            : VehicleCategory.fromJson(
                json['category'] as Map<String, dynamic>),
        type: json['type'] == null
            ? null
            : VehicleType.fromJson(json['type'] as Map<String, dynamic>),
        vehiclePhoto: json['vehicle_photo'] as String?,
        frontLicense: json['front_license'] as String?,
        backLicense: json['back_license'] as String?,
        vehicleMetalPlate: json['vehicle_metal_plate'] as String?,
        vehicleManufactureYear: json['vehicle_manufacture_year'] as String?,
        licenseExpiryDate: json['license_expiry_date'] as String?,
        confirmDocuments: json['confirm_documents'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'category': category?.toJson(),
        'type': type?.toJson(),
        'vehicle_photo': vehiclePhoto,
        'front_license': frontLicense,
        'back_license': backLicense,
        'vehicle_metal_plate': vehicleMetalPlate,
        'vehicle_manufacture_year': vehicleManufactureYear,
        'license_expiry_date': licenseExpiryDate,
        'confirm_documents': confirmDocuments,
      };
}
