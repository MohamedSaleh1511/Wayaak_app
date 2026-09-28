import 'datum.dart';

class CountriesModel {
  List<CountryDatum>? data;
  String? message;
  int? status;

  CountriesModel({this.data, this.message, this.status});

  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CountryDatum.fromJson(e as Map<String, dynamic>))
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
