class TimeAndMarketname {
  TimeAndMarketname({
    String? marketName,
    dynamic result,
  }) {
    _marketName = marketName;
    _result = result;
  }

  TimeAndMarketname.fromJson(dynamic json) {
    _marketName = json['MarketName'];
    _result = json['Result'];
  }
  String? _marketName;
  dynamic _result;
  TimeAndMarketname copyWith({
    String? marketName,
    dynamic result,
  }) =>
      TimeAndMarketname(
        marketName: marketName ?? _marketName,
        result: result ?? _result,
      );
  String? get marketName => _marketName;
  dynamic get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MarketName'] = _marketName;
    map['Result'] = _result;
    return map;
  }
}
