class OrderAcceptModel {
  dynamic data;
  String? message;
  int? status;

  OrderAcceptModel({this.data, this.message, this.status});

  factory OrderAcceptModel.fromJson(Map<String, dynamic> json) {
    return OrderAcceptModel(
      data: json['data'],
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'message': message,
        'status': status,
      };
}
