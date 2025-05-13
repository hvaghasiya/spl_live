class StarLineDailyMarketApiResponseModel {
  String? message;
  bool? status;
  List<StarlineMarketData>? data;

  StarLineDailyMarketApiResponseModel({this.message, this.status, this.data});

  StarLineDailyMarketApiResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <StarlineMarketData>[];
      json['data'].forEach((v) {
        data!.add(StarlineMarketData.fromJson(v));
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

class StarlineMarketData {
  int? id;
  String? market;
  String? time;
  String? date;
  int? result;
  bool? isBidOpen;
  bool? isResultDeclared;
  bool? isCoinDistributed;
  bool? isActive;
  bool? isBlocked;
  int? starlineMarketId;

  StarlineMarketData(
      {this.id,
      this.market,
      this.time,
      this.date,
      this.result,
      this.isBidOpen,
      this.isResultDeclared,
      this.isCoinDistributed,
      this.isActive,
      this.isBlocked,
      this.starlineMarketId});

  StarlineMarketData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    market = json['Market'];
    time = json['Time'];
    starlineMarketId = json['StarlineMarketId'];
    date = json['Date'];
    result = json['Result'];
    isBidOpen = json['IsBidOpen'];
    isResultDeclared = json['IsResultDeclared'];
    isCoinDistributed = json['IsCoinDistributed'];
    isActive = json['IsActive'];
    isBlocked = json['IsBlocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Market'] = market;
    data['Time'] = time;
    data['Date'] = date;
    data['StarlineMarketId'] = starlineMarketId;
    data['Result'] = result;
    data['IsBidOpen'] = isBidOpen;
    data['IsResultDeclared'] = isResultDeclared;
    data['IsCoinDistributed'] = isCoinDistributed;
    data['IsActive'] = isActive;
    data['IsBlocked'] = isBlocked;
    return data;
  }
}
