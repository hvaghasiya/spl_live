/// message : ""
/// status : true
/// data : {"id":20,"NotificationCount":0}

class NotifiactionCountModel {
  NotifiactionCountModel({
    String? message,
    bool? status,
    Data? data,
  }) {
    _message = message;
    _status = status;
    _data = data;
  }

  NotifiactionCountModel.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _status;
  Data? _data;
  NotifiactionCountModel copyWith({
    String? message,
    bool? status,
    Data? data,
  }) =>
      NotifiactionCountModel(
        message: message ?? _message,
        status: status ?? _status,
        data: data ?? _data,
      );
  String? get message => _message;
  bool? get status => _status;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// id : 20
/// NotificationCount : 0

class Data {
  Data({
    num? id,
    num? notificationCount,
  }) {
    _id = id;
    _notificationCount = notificationCount;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _notificationCount = json['NotificationCount'];
  }
  num? _id;
  num? _notificationCount;
  Data copyWith({
    num? id,
    num? notificationCount,
  }) =>
      Data(
        id: id ?? _id,
        notificationCount: notificationCount ?? _notificationCount,
      );
  num? get id => _id;
  num? get notificationCount => _notificationCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['NotificationCount'] = _notificationCount;
    return map;
  }
}
