import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wangyi_collect_model.g.dart';

@JsonSerializable()
class NewsBean extends BmobObject {
  BmobUser user;
  String path;
  String image;
  String title;
  DateTime passtime;

  NewsBean();

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }

  //此处与类名一致，由指令自动生成代码
  factory NewsBean.fromJson(Map<String, dynamic> json) =>
      _$NewsBeanFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$NewsBeanToJson(this);
}
