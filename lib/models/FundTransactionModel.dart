import 'dart:convert';

class FundTransactionModel {
  String? message;
  bool? status;
  int? count;
  List<FundTransactionList>? fundTransactionList;

  FundTransactionModel({
    this.message,
    this.status,
    this.count,
    this.fundTransactionList,
  });

  factory FundTransactionModel.fromRawJson(String str) => FundTransactionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FundTransactionModel.fromJson(Map<String, dynamic> json) => FundTransactionModel(
        message: json["message"],
        status: json["status"],
        count: json["count"],
        fundTransactionList: json["data"] == null
            ? []
            : List<FundTransactionList>.from(json["data"]!.map((x) => FundTransactionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "count": count,
        "FundTransactionList":
            fundTransactionList == null ? [] : List<dynamic>.from(fundTransactionList!.map((x) => x.toJson())),
      };
}

class FundTransactionList {
  dynamic id;
  int? userId;
  double? amount;
  String? paymentMode;
  String? orderId;
  DateTime? createdAt;
  String? clientRefId;
  String? status;

  FundTransactionList({
    this.id,
    this.userId,
    this.amount,
    this.paymentMode,
    this.orderId,
    this.createdAt,
    this.clientRefId,
    this.status,
  });

  factory FundTransactionList.fromRawJson(String str) => FundTransactionList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FundTransactionList.fromJson(Map<String, dynamic> json) => FundTransactionList(
        id: json["id"],
        userId: json["UserId"],
        amount: double.parse(json["Amount"].toString() ?? "0.0"),
        paymentMode: json["PaymentMode"],
        orderId: json["OrderId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        clientRefId: json["ClientRefId"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "UserId": userId,
        "Amount": amount,
        "PaymentMode": paymentMode,
        "OrderId": orderId,
        "createdAt": createdAt?.toIso8601String(),
        "ClientRefId": clientRefId,
        "Status": status,
      };
}
