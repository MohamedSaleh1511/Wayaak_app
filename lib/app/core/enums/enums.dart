import 'package:get/get.dart';

enum OtpType { register, forgetPass, verifyPhone }

enum OrderImportance {
  regular,
  urgent;

  int getId() => this == OrderImportance.regular ? 0 : 1;
  static OrderImportance fromJson(String json) => values.byName(json);
}

enum OrderStatus {
  pending,
  pendingPayment,
  waitingforDriver,
  driverAccepted,
  delivered,
  cancelled;

  String toJson() {
    String status = name.replaceAllMapped(
        RegExp(r'(?<!^)([A-Z])'), (Match match) => ' ${match.group(1)}');

    return status[0].toUpperCase() + status.substring(1);
  }

  static OrderStatus fromJson(String json) =>
      values.byName(json.replaceAll(' ', '')[0].toLowerCase() +
          json.replaceAll(' ', '').substring(1));
}

enum LocationsEntry { none, select }

enum AddEditLocationType { add, edit }

enum MesssageStatus { sent, loading, failed }

enum UserType {
  user,
  store;

  String toJson() {
    String status = name.capitalize!;
    return status;
  }

  static UserType fromJson(String json) => values.byName(json.toLowerCase());
}
