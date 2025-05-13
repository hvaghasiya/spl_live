class PaymentTransactionModel {
  String? message;
  bool? status;
  TransactionData? data;

  PaymentTransactionModel({this.message, this.status, this.data});

  PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new TransactionData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TransactionData {
  int? count;
  List<TransactionRow>? rows;

  TransactionData({this.count, this.rows});

  TransactionData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <TransactionRow>[];
      json['rows'].forEach((v) {
        rows!.add(new TransactionRow.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionRow {
  int? id;
  int? userId;
  String? clientRefId;
  String? orderId;
  int? amount;
  String? statusCode;
  String? paymentMode;
  String? status;
  String? transactionType;
  String? createdAt;
  String? updatedAt;

  TransactionRow(
      {this.id,
      this.userId,
      this.clientRefId,
      this.orderId,
      this.amount,
      this.statusCode,
      this.paymentMode,
      this.status,
      this.transactionType,
      this.createdAt,
      this.updatedAt});

  TransactionRow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['UserId'];
    clientRefId = json['ClientRefId'];
    orderId = json['OrderId'];
    amount = json['Amount'];
    statusCode = json['StatusCode'];
    paymentMode = json['PaymentMode'];
    status = json['Status'];
    transactionType = json['TransactionType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['UserId'] = this.userId;
    data['ClientRefId'] = this.clientRefId;
    data['OrderId'] = this.orderId;
    data['Amount'] = this.amount;
    data['StatusCode'] = this.statusCode;
    data['PaymentMode'] = this.paymentMode;
    data['Status'] = this.status;
    data['TransactionType'] = this.transactionType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
