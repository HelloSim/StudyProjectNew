// To parse this JSON data, do
//
//     final wangyiModel = wangyiModelFromJson(jsonString);

import 'dart:convert';

WangyiModel wangyiModelFromJson(String str) => WangyiModel.fromJson(json.decode(str));

String wangyiModelToJson(WangyiModel data) => json.encode(data.toJson());

class WangyiModel {
  WangyiModel({
    this.code,
    this.message,
    this.result,
  });

  int code;
  String message;
  List<Result> result;

  factory WangyiModel.fromJson(Map<String, dynamic> json) => WangyiModel(
    code: json["code"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.path,
    this.image,
    this.title,
    this.passtime,
  });

  String path;
  String image;
  String title;
  DateTime passtime;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    path: json["path"],
    image: json["image"],
    title: json["title"],
    passtime: DateTime.parse(json["passtime"]),
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "image": image,
    "title": title,
    "passtime": passtime.toIso8601String(),
  };
}
