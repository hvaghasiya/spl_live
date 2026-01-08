class LocationModel {
  String? city;
  String? country;
  String? state;
  String? street;
  String? postalCode;

  LocationModel({
    this.city,
    this.country,
    this.state,
    this.street,
    this.postalCode,
  });

  // Factory method to create a LocationModel from JSON
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'],
      country: json['country'],
      state: json['state'],
      street: json['street'],
      postalCode: json['postalCode'],
    );
  }

  // Convert a list of JSON objects to a list of LocationModel objects
  static List<LocationModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LocationModel.fromJson(json)).toList();
  }

  // Convert a LocationModel object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['country'] = country;
    data['state'] = state;
    data['street'] = street;
    data['postalCode'] = postalCode;
    return data;
  }
}
