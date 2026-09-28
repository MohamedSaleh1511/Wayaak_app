class GlobalResponseModel {
  bool? success;
  String? message;

  GlobalResponseModel({this.success, this.message});

  factory GlobalResponseModel.fromJson(Map<String, dynamic> json) {
    return GlobalResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}
