/// latitude : "456.09"
/// longitude : "54"
/// time : "rtyu"

class LocationModel {
  LocationModel({
      String? latitude, 
      String? longitude, 
      String? time,}){
    _latitude = latitude;
    _longitude = longitude;
    _time = time;
}

  LocationModel.fromJson(dynamic json) {
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _time = json['time'];
  }
  String? _latitude;
  String? _longitude;
  String? _time;
LocationModel copyWith({  String? latitude,
  String? longitude,
  String? time,
}) => LocationModel(  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  time: time ?? _time,
);
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['time'] = _time;
    return map;
  }

}