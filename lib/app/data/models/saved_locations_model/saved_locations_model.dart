import 'datum.dart';

class SavedLocationsModel {
  List<LocationDatum>? data;
  String? message;
  int? status;

  SavedLocationsModel({this.data, this.message, this.status});

  factory SavedLocationsModel.fromJson(Map<String, dynamic> json) {
    return SavedLocationsModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LocationDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'message': message,
        'status': status,
      };
}
