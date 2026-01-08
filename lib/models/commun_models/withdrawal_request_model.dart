class WithdrawalRequestResponseModel {
  String? message;
  bool? status;
  List<WithdrawalRequestList>? data;

  WithdrawalRequestResponseModel({this.message, this.status, this.data});

  WithdrawalRequestResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <WithdrawalRequestList>[];
      json['data'].forEach((v) {
        data!.add(WithdrawalRequestList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WithdrawalRequestList {
  int? id;
  int? requestedAmount;
  String? remarks;
  String? requestId;
  String? status;
  String? requestProcessedAt;
  String? requestTime;

  WithdrawalRequestList(
      {this.id,
      this.requestedAmount,
      this.remarks,
      this.requestId,
      this.status,
      this.requestProcessedAt,
      this.requestTime});

  WithdrawalRequestList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestedAmount = json['RequestedAmount'];
    remarks = json['Remarks'];
    requestId = json['RequestId'];
    status = json['Status'];
    requestProcessedAt = json['RequestProcessedAt'];
    requestTime = json['RequestTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['RequestedAmount'] = requestedAmount;
    data['Remarks'] = remarks;
    data['RequestId'] = requestId;
    data['Status'] = status;
    data['RequestProcessedAt'] = requestProcessedAt;
    data['RequestTime'] = requestTime;
    return data;
  }
}
