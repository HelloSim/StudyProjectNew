import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:traveltool_flutter/model/record_model.dart';
import 'package:traveltool_flutter/utils/preference_utils.dart';
import 'package:traveltool_flutter/utils/toast_util.dart';

class RecordMonthView extends StatefulWidget {
  final String arguments;

  const RecordMonthView({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordMonthViewState(this.arguments);
}

class _RecordMonthViewState extends State<RecordMonthView> {
  _RecordMonthViewState(String arguments);

  String arguments; //指定年月
  List<RecordBean> list = new List(); //月打卡数据
  bool _isLogIn = false;
  BmobUser _bmobUser = new BmobUser(); //登录用户

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (_isLogIn) {
        PreferenceUtils.instance.getString(PreferenceKey.USER).then((value) {
          Map<String, dynamic> map = convert.jsonDecode(value);
          _bmobUser.objectId = map['objectId'];
          _query(_bmobUser, arguments);
        });
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    PreferenceUtils.instance
        .getBool(PreferenceKey.ISLOGIN, false)
        .then((index) => _isLogIn = index);
    return Container(
        child: Scaffold(
            appBar: AppBar(title: Text("$arguments记录")),
            body: _getBodyWidget(list)));
  }

  ///查询数据
  _query(var user, String yearAndMonth) async {
    BmobQuery<RecordBean> query = BmobQuery();
    query.addWhereEqualTo("user", user);
    query.addWhereEqualTo("yearAndMonth", yearAndMonth);
    await query.queryObjects().then((data) {
      if (data.length > 0) {
        list.clear();
        list = data.map((i) => RecordBean.fromJson(i)).toList();
        setState(() {});
      } else {
        ToastUtil.instance.show("当月无打卡记录！");
        Navigator.pop(context);
      }
    }).catchError((e) {
      print("查询数据失败：$e");
    });
  }

  Widget _getBodyWidget(List<RecordBean> list) {
    var _sortAscending = true;
    var _sortColumnIndex = 0;
    List<DataRow> dateRows = [];
    for (int i = 0; i < list.length; i++) {
      dateRows.add(DataRow(
        cells: [
          DataCell(Text(list[i].serial != null ? "${list[i].serial}" : "")),
          DataCell(Text(list[i].week != null ? "${list[i].week}" : "")),
          DataCell(Text(
            list[i].startTime != null ? "${list[i].startTime}" : "",
            style: TextStyle(color: list[i].isLate ? Colors.red : Colors.black),
          )),
          DataCell(
            Text(
              list[i].endTime != null ? "${list[i].endTime}" : "",
              style: TextStyle(
                  color: list[i].isLeaveEarly ? Colors.red : Colors.black),
            ),
          ),
          DataCell(Text(list[i].other != null ? "${list[i].other}" : "")),
        ],
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.lightGreen),
              sortColumnIndex: 0,
              sortAscending: true,
              columns: [
                DataColumn(
                    label: Text('日期'),
                    onSort: (int columnIndex, bool ascending) {
                      setState(() {
                        list.sort((a, b) => a.serial.compareTo(b.serial));
                      });
                    }),
                DataColumn(label: Text('星期')),
                DataColumn(label: Text("上班时间")),
                DataColumn(label: Text("下班时间")),
                DataColumn(label: Text("备忘")),
              ],
              rows: dateRows)),
    );
  }

  //排序,
  void _sort<T>(Comparable<T> getField(RecordBean shop), bool b) {
    list.sort((RecordBean s1, RecordBean s2) {
      if (!b) {
        //两个项进行交换
        final RecordBean temp = s1;
        s1 = s2;
        s2 = temp;
      }
      final Comparable<T> s1Value = getField(s1);
      final Comparable<T> s2Value = getField(s2);
      return Comparable.compare(s1Value, s2Value);
    });
    setState(() {});
  }
}
