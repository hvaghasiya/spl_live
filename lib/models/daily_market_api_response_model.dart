class DailyMarketApiResponseModel {
  String? message;
  bool? status;
  List<MarketData>? data;

  DailyMarketApiResponseModel({this.message, this.status, this.data});

  DailyMarketApiResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <MarketData>[];
      json['data'].forEach((v) {
        data!.add(MarketData.fromJson(v));
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

class MarketData {
  int? id;
  int? marketId;
  String? market;
  String? openTime;
  String? closeTime;
  String? date;
  int? openResult;
  int? closeResult;
  bool? isBidOpenForOpen;
  bool? isBidOpenForClose;
  bool? isOpenResultDeclared;
  bool? isCloseResultDeclared;
  bool? isCoinDistributedForOpen;
  bool? isCoinDistributedForClose;
  bool? isActive;
  bool? isBlocked;

  MarketData({
    this.id,
    this.market,
    this.openTime,
    this.closeTime,
    this.date,
    this.openResult,
    this.closeResult,
    this.isBidOpenForOpen,
    this.isBidOpenForClose,
    this.isOpenResultDeclared,
    this.isCloseResultDeclared,
    this.isCoinDistributedForOpen,
    this.isCoinDistributedForClose,
    this.isActive,
    this.isBlocked,
    this.marketId,
  });

  MarketData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    market = json['Market'];
    marketId = json['MarketId'];
    openTime = json['OpenTime'];
    closeTime = json['CloseTime'];
    date = json['Date'];
    openResult = json['OpenResult'];
    closeResult = json['CloseResult'];
    isBidOpenForOpen = json['IsBidOpenForOpen'];
    isBidOpenForClose = json['IsBidOpenForClose'];
    isOpenResultDeclared = json['IsOpenResultDeclared'];
    isCloseResultDeclared = json['IsCloseResultDeclared'];
    isCoinDistributedForOpen = json['IsCoinDistributedForOpen'];
    isCoinDistributedForClose = json['IsCoinDistributedForClose'];
    isActive = json['IsActive'];
    isBlocked = json['IsBlocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Market'] = market;
    data['MarketId'] = marketId;
    data['OpenTime'] = openTime;
    data['CloseTime'] = closeTime;
    data['Date'] = date;
    data['OpenResult'] = openResult;
    data['CloseResult'] = closeResult;
    data['IsBidOpenForOpen'] = isBidOpenForOpen;
    data['IsBidOpenForClose'] = isBidOpenForClose;
    data['IsOpenResultDeclared'] = isOpenResultDeclared;
    data['IsCloseResultDeclared'] = isCloseResultDeclared;
    data['IsCoinDistributedForOpen'] = isCoinDistributedForOpen;
    data['IsCoinDistributedForClose'] = isCoinDistributedForClose;
    data['IsActive'] = isActive;
    data['isBlocked'] = isBlocked;
    return data;
  }
}
