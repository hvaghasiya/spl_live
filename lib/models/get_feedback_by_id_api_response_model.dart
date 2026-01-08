class GetFeedbackByIdApiResponseModel {
  String? message;
  bool? status;
  Data? data;

  GetFeedbackByIdApiResponseModel({this.message, this.status, this.data});

  GetFeedbackByIdApiResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  int? userId;
  String? feedback;
  int? rating;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  User? user;

  Data(
      {this.id,
      this.userId,
      this.feedback,
      this.rating,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['UserId'];
    feedback = json['Feedback'];
    rating = json['Rating'];
    isActive = json['IsActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['UserId'] = userId;
    data['Feedback'] = feedback;
    data['Rating'] = rating;
    data['IsActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? fullName;
  String? userName;
  dynamic appRating;

  User({this.fullName, this.userName});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['FullName'];
    userName = json['UserName'];
    appRating = json['AppRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FullName'] = fullName;
    data['UserName'] = userName;
    data['AppRating'] = appRating;
    return data;
  }
}
