/// message : ""
/// status : true
/// data : {"rows":[{"id":3,"Title":"WELCOME","Description":"HI USERS","Notification":null,"IsPreSchedule":false,"ScheduleDateAndTime":null,"IsActive":true,"createdAt":"2023-08-21T10:09:16.605Z","updatedAt":"2023-08-21T10:09:16.605Z"},{"id":2,"Title":"deposit","Description":"hi deposit on123456789","Notification":null,"IsPreSchedule":false,"ScheduleDateAndTime":null,"IsActive":true,"createdAt":"2023-08-20T12:16:10.687Z","updatedAt":"2023-08-20T12:16:10.687Z"},{"id":1,"Title":"welcome","Description":"hi user","Notification":null,"IsPreSchedule":false,"ScheduleDateAndTime":null,"IsActive":true,"createdAt":"2023-08-20T11:27:49.259Z","updatedAt":"2023-08-20T11:27:49.259Z"}],"count":3}

class GetAllNotificationsData {
  GetAllNotificationsData({
    String? message,
    bool? status,
    Data? data,
  }) {
    _message = message;
    _status = status;
    _data = data;
  }

  GetAllNotificationsData.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _status;
  Data? _data;
  GetAllNotificationsData copyWith({
    String? message,
    bool? status,
    Data? data,
  }) =>
      GetAllNotificationsData(
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

/// rows : [{"id":3,"Title":"WELCOME","Description":"HI USERS","Notification":null,"IsPreSchedule":false,"ScheduleDateAndTime":null,"IsActive":true,"createdAt":"2023-08-21T10:09:16.605Z","updatedAt":"2023-08-21T10:09:16.605Z"},{"id":2,"Title":"deposit","Description":"hi deposit on123456789","Notification":null,"IsPreSchedule":false,"ScheduleDateAndTime":null,"IsActive":true,"createdAt":"2023-08-20T12:16:10.687Z","updatedAt":"2023-08-20T12:16:10.687Z"},{"id":1,"Title":"welcome","Description":"hi user","Notification":null,"IsPreSchedule":false,"ScheduleDateAndTime":null,"IsActive":true,"createdAt":"2023-08-20T11:27:49.259Z","updatedAt":"2023-08-20T11:27:49.259Z"}]
/// count : 3

class Data {
  Data({
    List<NotificationData>? rows,
    num? count,
  }) {
    _rows = rows;
    _count = count;
  }

  Data.fromJson(dynamic json) {
    if (json['rows'] != null) {
      _rows = [];
      json['rows'].forEach((v) {
        _rows?.add(NotificationData.fromJson(v));
      });
    }
    _count = json['count'];
  }
  List<NotificationData>? _rows;
  num? _count;
  Data copyWith({
    List<NotificationData>? rows,
    num? count,
  }) =>
      Data(
        rows: rows ?? _rows,
        count: count ?? _count,
      );
  List<NotificationData>? get rows => _rows;
  num? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_rows != null) {
      map['rows'] = _rows?.map((v) => v.toJson()).toList();
    }
    map['count'] = _count;
    return map;
  }
}

/// id : 3
/// Title : "WELCOME"
/// Description : "HI USERS"
/// Notification : null
/// IsPreSchedule : false
/// ScheduleDateAndTime : null
/// IsActive : true
/// createdAt : "2023-08-21T10:09:16.605Z"
/// updatedAt : "2023-08-21T10:09:16.605Z"

class NotificationData {
  NotificationData({
    num? id,
    String? title,
    String? description,
    dynamic notification,
    bool? isPreSchedule,
    dynamic scheduleDateAndTime,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _title = title;
    _description = description;
    _notification = notification;
    _isPreSchedule = isPreSchedule;
    _scheduleDateAndTime = scheduleDateAndTime;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  NotificationData.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['Title'];
    _description = json['Description'];
    _notification = json['Notification'];
    _isPreSchedule = json['IsPreSchedule'];
    _scheduleDateAndTime = json['ScheduleDateAndTime'];
    _isActive = json['IsActive'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _title;
  String? _description;
  dynamic _notification;
  bool? _isPreSchedule;
  dynamic _scheduleDateAndTime;
  bool? _isActive;
  String? _createdAt;
  String? _updatedAt;
  NotificationData copyWith({
    num? id,
    String? title,
    String? description,
    dynamic notification,
    bool? isPreSchedule,
    dynamic scheduleDateAndTime,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
  }) =>
      NotificationData(
        id: id ?? _id,
        title: title ?? _title,
        description: description ?? _description,
        notification: notification ?? _notification,
        isPreSchedule: isPreSchedule ?? _isPreSchedule,
        scheduleDateAndTime: scheduleDateAndTime ?? _scheduleDateAndTime,
        isActive: isActive ?? _isActive,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  String? get title => _title;
  String? get description => _description;
  dynamic get notification => _notification;
  bool? get isPreSchedule => _isPreSchedule;
  dynamic get scheduleDateAndTime => _scheduleDateAndTime;
  bool? get isActive => _isActive;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Title'] = _title;
    map['Description'] = _description;
    map['Notification'] = _notification;
    map['IsPreSchedule'] = _isPreSchedule;
    map['ScheduleDateAndTime'] = _scheduleDateAndTime;
    map['IsActive'] = _isActive;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
