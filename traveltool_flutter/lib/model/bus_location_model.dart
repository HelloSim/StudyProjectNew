// To parse this JSON data, do
//
//     final busLocationModel = busLocationModelFromJson(jsonString);

import 'dart:convert';

BusLocationModel busLocationModelFromJson(String str) => BusLocationModel.fromJson(json.decode(str));

String busLocationModelToJson(BusLocationModel data) => json.encode(data.toJson());

class BusLocationModel {
  BusLocationModel({
    this.status,
    this.count,
    this.info,
    this.infocode,
    this.tips,
  });

  String status;
  String count;
  String info;
  String infocode;
  List<Tip> tips;

  factory BusLocationModel.fromJson(Map<String, dynamic> json) => BusLocationModel(
    status: json["status"],
    count: json["count"],
    info: json["info"],
    infocode: json["infocode"],
    tips: List<Tip>.from(json["tips"].map((x) => Tip.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "info": info,
    "infocode": infocode,
    "tips": List<dynamic>.from(tips.map((x) => x.toJson())),
  };
}

class Tip {
  Tip({
    this.id,
    this.name,
    this.district,
    this.adcode,
    this.location,
    this.address,
    this.typecode,
    this.city,
  });

  dynamic id;
  String name;
  District district;
  String adcode;
  dynamic location;
  dynamic address;
  String typecode;
  List<dynamic> city;

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
    id: json["id"],
    name: json["name"],
    district: districtValues.map[json["district"]],
    adcode: json["adcode"],
    location: json["location"],
    address: json["address"],
    typecode: json["typecode"],
    city: List<dynamic>.from(json["city"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "district": districtValues.reverse[district],
    "adcode": adcode,
    "location": location,
    "address": address,
    "typecode": typecode,
    "city": List<dynamic>.from(city.map((x) => x)),
  };
}

enum District { EMPTY, DISTRICT, PURPLE }

final districtValues = EnumValues({
  "广东省珠海市金湾区": District.DISTRICT,
  "广东省珠海市香洲区": District.EMPTY,
  "广东省珠海市": District.PURPLE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
