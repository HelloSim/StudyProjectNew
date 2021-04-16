import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'record_model.g.dart';

@JsonSerializable()
class RecordBean extends BmobObject {
  BmobUser user; //打卡人
  String date; //日期 2020-12-31
  String yearAndMonth; //年月
  String week; //周几 星期四
  String startTime; //上班卡时间 09:00
  String endTime; //下班卡时间 19:00
  bool isLate; //是否迟到 false
  bool isLeaveEarly; //是否早退
  String other; //其他
  int serial; //序号

  RecordBean(
      {this.user,
      this.date,
      this.yearAndMonth,
      this.week,
      this.startTime,
      this.endTime,
      this.isLate,
      this.isLeaveEarly,
      this.other,
      this.serial});

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }

  //此处与类名一致，由指令自动生成代码
  factory RecordBean.fromJson(Map<String, dynamic> json) =>
      _$RecordBeanFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$RecordBeanToJson(this);
}
