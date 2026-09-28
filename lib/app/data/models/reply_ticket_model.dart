class ReplyTicketModel {
  List<dynamic>? data;
  String? message;
  int? status;

  ReplyTicketModel({this.data, this.message, this.status});

  factory ReplyTicketModel.fromJson(Map<String, dynamic> json) {
    return ReplyTicketModel(
      data: json['data'] as List<dynamic>?,
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
