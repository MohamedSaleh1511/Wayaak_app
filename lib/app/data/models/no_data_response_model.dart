class NoDataResponseModel {
  dynamic data;
  String? message;
  int? status;

  NoDataResponseModel({this.data, this.message, this.status});

  factory NoDataResponseModel.fromJson(Map<String, dynamic> json) {
    return NoDataResponseModel(
      data: json['data'] as dynamic,
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'message': message,
        'status': status,
      };
}
