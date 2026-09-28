class Data {
  int? balance;

  Data({this.balance});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        balance: json['balance'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'balance': balance,
      };
}
