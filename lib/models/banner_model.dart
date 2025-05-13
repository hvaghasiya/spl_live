/// message : ""
/// status : true
/// data : [{"id":1,"Banner":"http://35.154.94.107:9869/public/banner/test-1.jpeg","Key":"test","IsActive":true,"Priority":1,"createdAt":"2023-08-29T13:11:03.958Z","updatedAt":"2023-08-29T13:11:03.958Z"}]

class BannerModel {
  BannerModel({
    String? message,
    bool? status,
    List<BannerData>? data,
  }) {
    _message = message;
    _status = status;
    _data = data;
  }

  BannerModel.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(BannerData.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _status;
  List<BannerData>? _data;
  BannerModel copyWith({
    String? message,
    bool? status,
    List<BannerData>? data,
  }) =>
      BannerModel(
        message: message ?? _message,
        status: status ?? _status,
        data: data ?? _data,
      );
  String? get message => _message;
  bool? get status => _status;
  List<BannerData>? get data => _data;

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
/// Banner : "http://35.154.94.107:9869/public/banner/test-1.jpeg"
/// Key : "test"
/// IsActive : true
/// Priority : 1
/// createdAt : "2023-08-29T13:11:03.958Z"
/// updatedAt : "2023-08-29T13:11:03.958Z"

class BannerData {
  BannerData({
    num? id,
    String? banner,
    String? key,
    bool? isActive,
    num? priority,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _banner = banner;
    _key = key;
    _isActive = isActive;
    _priority = priority;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  BannerData.fromJson(dynamic json) {
    _id = json['id'];
    _banner = json['Banner'];
    _key = json['Key'];
    _isActive = json['IsActive'];
    _priority = json['Priority'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _banner;
  String? _key;
  bool? _isActive;
  num? _priority;
  String? _createdAt;
  String? _updatedAt;
  BannerData copyWith({
    num? id,
    String? banner,
    String? key,
    bool? isActive,
    num? priority,
    String? createdAt,
    String? updatedAt,
  }) =>
      BannerData(
        id: id ?? _id,
        banner: banner ?? _banner,
        key: key ?? _key,
        isActive: isActive ?? _isActive,
        priority: priority ?? _priority,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  String? get banner => _banner;
  String? get key => _key;
  bool? get isActive => _isActive;
  num? get priority => _priority;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Banner'] = _banner;
    map['Key'] = _key;
    map['IsActive'] = _isActive;
    map['Priority'] = _priority;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
