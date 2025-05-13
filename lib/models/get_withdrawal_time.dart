class GetWithdrawalTiming {
  String? message;
  bool? status;
  GetWithdrawalData? data;

  GetWithdrawalTiming({this.message, this.status, this.data});

  GetWithdrawalTiming.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? GetWithdrawalData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetWithdrawalData {
  int? id;
  int? operationalDayId;
  double? minimumAmount;
  String? openTime;
  String? closeTime;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  GetWithdrawalData(
      {this.id,
      this.operationalDayId,
      this.minimumAmount,
      this.openTime,
      this.closeTime,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  GetWithdrawalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operationalDayId = json['OperationalDayId'];
    minimumAmount = double.parse("${json['MinimumAmount'] ?? "0.0"}");
    openTime = json['OpenTime'];
    closeTime = json['CloseTime'];
    isActive = json['IsActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['OperationalDayId'] = operationalDayId;
    data['MinimumAmount'] = minimumAmount;
    data['OpenTime'] = openTime;
    data['CloseTime'] = closeTime;
    data['IsActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
