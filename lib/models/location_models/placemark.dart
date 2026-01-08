import 'location_model.dart';

class PlaceMark {
  String? name;
  LocationModel? location;

  PlaceMark({this.name, this.location});

  // Factory method to create a PlaceMark from JSON
  factory PlaceMark.fromJson(Map<String, dynamic> json) {
    return PlaceMark(
      name: json['name'],
      location: LocationModel.fromJson(json['location']),
    );
  }

  // Convert a list of JSON objects to a list of PlaceMark objects
  static List<PlaceMark> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PlaceMark.fromJson(json)).toList();
  }

  // Convert a PlaceMark object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['location'] = location?.toJson();
    return data;
  }
}
