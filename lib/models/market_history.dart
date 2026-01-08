class MarketHistoryModel {
  String? message;
  bool? status;
  List<MarketHistoryList>? data;

  MarketHistoryModel({this.message, this.status, this.data});

  MarketHistoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <MarketHistoryList>[];
      json['data'].forEach((v) {
        data!.add(new MarketHistoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MarketHistoryList {
  int? id;
  String? name;
  int? openResult;
  int? closeResult;
  bool? IsOpenResultDeclared;
  bool? IsCloseResultDeclared;
  String? createdAt;
  String? updatedAt;

  MarketHistoryList(
      {this.id,
      this.name,
      this.openResult,
      this.closeResult,
      this.createdAt,
      this.updatedAt,
      this.IsOpenResultDeclared,
      this.IsCloseResultDeclared});

  MarketHistoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    openResult = json['openResult'];
    closeResult = json['closeResult'];
    IsOpenResultDeclared = json['IsOpenResultDeclared'];
    IsCloseResultDeclared = json['IsCloseResultDeclared'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['openResult'] = openResult;
    data['closeResult'] = closeResult;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
