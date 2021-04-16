// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wangyi_collect_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsBean _$NewsBeanFromJson(Map<String, dynamic> json) {
  return NewsBean()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..user = json['user'] == null
        ? null
        : BmobUser.fromJson(json['user'] as Map<String, dynamic>)
    ..path = json['path'] as String
    ..image = json['image'] as String
    ..title = json['title'] as String
    ..passtime = json['passtime'] == null
        ? null
        : DateTime.parse(json['passtime'] as String);
}

Map<String, dynamic> _$NewsBeanToJson(NewsBean instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'user': instance.user,
      'path': instance.path,
      'image': instance.image,
      'title': instance.title,
      'passtime': instance.passtime?.toIso8601String(),
    };
