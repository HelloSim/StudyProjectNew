// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordBean _$RecordBeanFromJson(Map<String, dynamic> json) {
  return RecordBean(
    user: json['user'] == null
        ? null
        : BmobUser.fromJson(json['user'] as Map<String, dynamic>),
    date: json['date'] as String,
    yearAndMonth: json['yearAndMonth'] as String,
    week: json['week'] as String,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    isLate: json['isLate'] as bool,
    isLeaveEarly: json['isLeaveEarly'] as bool,
    other: json['other'] as String,
    serial: json['serial'] as int,
  )
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>;
}

Map<String, dynamic> _$RecordBeanToJson(RecordBean instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'user': instance.user,
      'date': instance.date,
      'yearAndMonth': instance.yearAndMonth,
      'week': instance.week,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isLate': instance.isLate,
      'isLeaveEarly': instance.isLeaveEarly,
      'other': instance.other,
      'serial': instance.serial,
    };
