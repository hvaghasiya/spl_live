/// message : "Success"
/// status : true
/// data : [{"id":1,"value":100},{"id":2,"value":500},{"id":3,"value":1000},{"id":4,"value":5000},{"id":5,"value":10000}]

class TicketsModel {
  TicketsModel({
    String? message,
    bool? status,
    List<TicketsDataModel>? data,
  }) {
    _message = message;
    _status = status;
    _data = data;
  }

  TicketsModel.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(TicketsDataModel.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _status;
  List<TicketsDataModel>? _data;
  TicketsModel copyWith({
    String? message,
    bool? status,
    List<TicketsDataModel>? data,
  }) =>
      TicketsModel(
        message: message ?? _message,
        status: status ?? _status,
        data: data ?? _data,
      );
  String? get message => _message;
  bool? get status => _status;
  List<TicketsDataModel>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// value : 100

class TicketsDataModel {
  TicketsDataModel({
    num? id,
    num? value,
    bool? isSelected,
  }) {
    _id = id;
    _value = value;
    _isSelected = isSelected;
  }

  TicketsDataModel.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
    _isSelected = json['isSelected'];
  }
  num? _id;
  num? _value;
  bool? _isSelected;
  TicketsDataModel copyWith({
    num? id,
    num? value,
    bool? isSelected,
  }) =>
      TicketsDataModel(
        id: id ?? _id,
        value: value ?? _value,
        isSelected: isSelected ?? _isSelected,
      );
  num? get id => _id;
  num? get value => _value;
  bool? get isSelected => _isSelected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    map['isSelected'] = _isSelected;
    return map;
  }
}
