/// message : "Bank detail History"
/// status : true
/// data : [{"id":8,"UserId":3,"BankName":"SBI","AccountHolderName":"darshit","AccountNumber":"47896248652","IFSCCode":"SBI000056","IsPrimary":true,"createdAt":"2024-03-14T05:56:10.930Z","updatedAt":"2024-03-14T05:56:10.954Z"},{"id":4,"UserId":3,"BankName":"Union","AccountHolderName":"Darshit","AccountNumber":"7898545621","IFSCCode":"UN00001","IsPrimary":false,"createdAt":"2024-03-13T12:27:55.333Z","updatedAt":"2024-03-14T05:56:10.947Z"},{"id":3,"UserId":3,"BankName":"Kotak","AccountHolderName":"Darshit","AccountNumber":"123456789","IFSCCode":"KB00003","IsPrimary":false,"createdAt":"2024-03-13T12:25:59.752Z","updatedAt":"2024-03-14T05:56:10.947Z"},{"id":1,"UserId":3,"BankName":"HDFC","AccountHolderName":"Darshit","AccountNumber":"789541235652","IFSCCode":"HDFC00001","IsPrimary":false,"createdAt":"2024-02-28T09:06:36.593Z","updatedAt":"2024-03-14T05:56:10.947Z"}]

class BankHistory {
  BankHistory({
    String? message,
    bool? status,
    List<BankHistoryData>? data,
  }) {
    _message = message;
    _status = status;
    _data = data;
  }

  BankHistory.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(BankHistoryData.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _status;
  List<BankHistoryData>? _data;
  BankHistory copyWith({
    String? message,
    bool? status,
    List<BankHistoryData>? data,
  }) =>
      BankHistory(
        message: message ?? _message,
        status: status ?? _status,
        data: data ?? _data,
      );
  String? get message => _message;
  bool? get status => _status;
  List<BankHistoryData>? get data => _data;

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

/// id : 8
/// UserId : 3
/// BankName : "SBI"
/// AccountHolderName : "darshit"
/// AccountNumber : "47896248652"
/// IFSCCode : "SBI000056"
/// IsPrimary : true
/// createdAt : "2024-03-14T05:56:10.930Z"
/// updatedAt : "2024-03-14T05:56:10.954Z"

class BankHistoryData {
  BankHistoryData({
    num? id,
    num? userId,
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    String? iFSCCode,
    bool? isPrimary,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _bankName = bankName;
    _accountHolderName = accountHolderName;
    _accountNumber = accountNumber;
    _iFSCCode = iFSCCode;
    _isPrimary = isPrimary;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  BankHistoryData.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['UserId'];
    _bankName = json['BankName'];
    _accountHolderName = json['AccountHolderName'];
    _accountNumber = json['AccountNumber'];
    _iFSCCode = json['IFSCCode'];
    _isPrimary = json['IsPrimary'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  num? _userId;
  String? _bankName;
  String? _accountHolderName;
  String? _accountNumber;
  String? _iFSCCode;
  bool? _isPrimary;
  String? _createdAt;
  String? _updatedAt;
  BankHistoryData copyWith({
    num? id,
    num? userId,
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    String? iFSCCode,
    bool? isPrimary,
    String? createdAt,
    String? updatedAt,
  }) =>
      BankHistoryData(
        id: id ?? _id,
        userId: userId ?? _userId,
        bankName: bankName ?? _bankName,
        accountHolderName: accountHolderName ?? _accountHolderName,
        accountNumber: accountNumber ?? _accountNumber,
        iFSCCode: iFSCCode ?? _iFSCCode,
        isPrimary: isPrimary ?? _isPrimary,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get userId => _userId;
  String? get bankName => _bankName;
  String? get accountHolderName => _accountHolderName;
  String? get accountNumber => _accountNumber;
  String? get iFSCCode => _iFSCCode;
  bool? get isPrimary => _isPrimary;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['UserId'] = _userId;
    map['BankName'] = _bankName;
    map['AccountHolderName'] = _accountHolderName;
    map['AccountNumber'] = _accountNumber;
    map['IFSCCode'] = _iFSCCode;
    map['IsPrimary'] = _isPrimary;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
