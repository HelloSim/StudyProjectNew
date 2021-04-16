import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traveltool_flutter/model/event_bus.dart';
import 'package:traveltool_flutter/model/record_model.dart';
import 'package:traveltool_flutter/utils/preference_utils.dart';
import 'package:traveltool_flutter/utils/toast_util.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert' as convert;

class RecordView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  CalendarController _calendarController;

  var eventBusFn;
  bool _isLogIn = false; //是否登录
  BmobUser _bmobUser = new BmobUser(); //登录用户
  DateTime _dateTimeSelected = DateTime.now(); //当前选中日期，默认是当天
  RecordBean _recordBeanSelected; //选中日期的打卡记录实体

  TextEditingController _otherController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    Future.delayed(Duration(seconds: 1), () {
      if (_isLogIn) {
        PreferenceUtils.instance.getString(PreferenceKey.USER).then((value) {
          Map<String, dynamic> map = convert.jsonDecode(value);
          _bmobUser.objectId = map['objectId'];
          _query(_bmobUser,
              "${_dateTimeSelected.year}-${_dateTimeSelected.month}-${_dateTimeSelected.day}");
        });
      }
    });
    this.eventBusFn = eventBus.on().listen((event) {
      switch (event.runtimeType.toString()) {
        case "IsLogin":
          _isLogIn = event.isLogin;
          if (_isLogIn) {
            PreferenceUtils.instance
                .getString(PreferenceKey.USER)
                .then((value) {
              Map<String, dynamic> map = convert.jsonDecode(value);
              _bmobUser.objectId = map['objectId'];
              _query(_bmobUser,
                  "${_dateTimeSelected.year}-${_dateTimeSelected.month}-${_dateTimeSelected.day}");
            });
          } else {
            setState(() {});
          }
          break;
        case "More":
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      FlatButton(
                        child: new Text(
                          "添加备忘",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _addOther();
                        },
                      ),
                      FlatButton(
                        child: new Text(
                          "打卡记录",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          if (_isLogIn) {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, '/RecordMonthView',
                                arguments:
                                    "${_dateTimeSelected.year}${_dateTimeSelected.month}");
                          } else {
                            ToastUtil.instance.show("未登录！");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
    eventBusFn.cancel();
  }

  @override
  Widget build(BuildContext context) {
    PreferenceUtils.instance
        .getBool(PreferenceKey.ISLOGIN, false)
        .then((index) => _isLogIn = index);
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      TableCalendar(
        calendarController: _calendarController,
        locale: 'zh_CN',
        onDaySelected: _onDaySelected,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              (_recordBeanSelected != null &&
                      _recordBeanSelected.startTime != null)
                  ? "${_recordBeanSelected.startTime}"
                  : "未打卡",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          Text(" -- ",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          Text(
              (_recordBeanSelected != null &&
                      _recordBeanSelected.endTime != null)
                  ? "${_recordBeanSelected.endTime}"
                  : "未打卡",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 30.0),
        width: 130.0,
        height: 130.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, //可以设置角度，BoxShape.circle直接圆形
            // borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(!_isLogIn
                  ? "images/record/record_no_login.png"
                  : (_recordBeanSelected != null &&
                          _recordBeanSelected.startTime != null)
                      ? "images/record/record_end.png"
                      : "images/record/record_start.png"),
            )),
        child: GestureDetector(onTap: () => _recoed()),
      ),
    ]));
  }

  ///日历选择日期监听
  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      // _selectedEvents = events;
      _dateTimeSelected = day;
      if (_isLogIn) {
        PreferenceUtils.instance.getString(PreferenceKey.USER).then((value) {
          Map<String, dynamic> map = convert.jsonDecode(value);
          _bmobUser.objectId = map['objectId'];
          _query(_bmobUser,
              "${_dateTimeSelected.year}-${_dateTimeSelected.month}-${_dateTimeSelected.day}");
        });
      }
    });
  }

  ///打卡操作
  _recoed() {
    if (_isLogIn) {
      if (_dateTimeSelected.year == DateTime.now().year &&
          _dateTimeSelected.month == DateTime.now().month &&
          _dateTimeSelected.day == DateTime.now().day) {
        if (_recordBeanSelected == null) {
          _save(new RecordBean(
              user: _bmobUser,
              serial: _dateTimeSelected.day,
              date:
                  "${_dateTimeSelected.year}-${_dateTimeSelected.month}-${_dateTimeSelected.day}",
              yearAndMonth:
                  "${_dateTimeSelected.year}${_dateTimeSelected.month}",
              week: DateFormat('EEEE', "zh_CN").format(_dateTimeSelected),
              startTime: "${DateTime.now().hour}:${DateTime.now().minute}",
              isLate: (DateTime.now().hour > 9 ||
                  (DateTime.now().hour == 9 && DateTime.now().minute > 30)),
              isLeaveEarly: false));
        } else {
          if (_recordBeanSelected.startTime == null) {
            _recordBeanSelected.startTime =
                "${DateTime.now().hour}:${DateTime.now().minute}";
            _recordBeanSelected.isLate = (DateTime.now().hour > 9 ||
                (DateTime.now().hour == 9 && DateTime.now().minute > 30));
            _update(_recordBeanSelected); //上班卡
          } else {
            _recordBeanSelected.endTime =
                "${DateTime.now().hour}:${DateTime.now().minute}";
            _recordBeanSelected.isLeaveEarly = (DateTime.now().hour < 18 ||
                (DateTime.now().hour == 18 && DateTime.now().minute < 30));
            _update(_recordBeanSelected);
          }
        }
      } else {
        ToastUtil.instance.show("只能操作当天打卡！");
      }
    } else {
      ToastUtil.instance.show("未登录！");
    }
  }

  ///添加备忘操作
  void _addOther() {
    if (_isLogIn) {
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: "添加备忘"),
                    controller: _otherController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _otherController.text = "";
                },
              ),
              FlatButton(
                child: new Text("确定"),
                onPressed: () async {
                  if (_otherController.value.text.isNotEmpty) {
                    BmobQuery<RecordBean> query = BmobQuery();
                    query.addWhereEqualTo("user", _bmobUser);
                    query.addWhereEqualTo("date",
                        "${_dateTimeSelected.year}-${_dateTimeSelected.month}-${_dateTimeSelected.day}");
                    await query.queryObjects().then((data) {
                      if (data.length > 0) {
                        List<RecordBean> list =
                            data.map((i) => RecordBean.fromJson(i)).toList();
                        if (list.length > 0) {
                          list[0].other = _otherController.value.text;
                          _update(list[0]);
                        }
                      } else {
                        _save(new RecordBean(
                            user: _bmobUser,
                            serial: _dateTimeSelected.day,
                            date:
                                "${_dateTimeSelected.year}-${_dateTimeSelected.month}-${_dateTimeSelected.day}",
                            yearAndMonth:
                                "${_dateTimeSelected.year}${_dateTimeSelected.month}",
                            week: DateFormat('EEEE', "zh_CN")
                                .format(_dateTimeSelected),
                            isLate: false,
                            isLeaveEarly: false,
                            other: _otherController.value.text));
                      }
                    }).catchError((e) {});
                    Navigator.of(context).pop();
                    _otherController.text = "";
                  } else {
                    Navigator.of(context).pop();
                    _otherController.text = "";
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      ToastUtil.instance.show("未登录！");
    }
  }

  ///查询数据
  _query(var user, String date) async {
    BmobQuery<RecordBean> query = BmobQuery();
    query.addWhereEqualTo("user", user);
    query.addWhereEqualTo("date", date);
    await query.queryObjects().then((data) {
      if (data.length > 0) {
        List<RecordBean> list =
            data.map((i) => RecordBean.fromJson(i)).toList();
        _recordBeanSelected = list[0];
      } else {
        _recordBeanSelected = null;
      }
      setState(() {});
    }).catchError((e) {
      print("查询数据失败：$e");
    });
  }

  ///保存数据
  void _save(RecordBean bean) {
    bean.save().then((BmobSaved bmobSaved) {
      setState(() {
        _recordBeanSelected = bean;
      });
    }).catchError((e) {
      print("插入数据失败：$e");
    });
  }

  ///修改一条数据
  _update(RecordBean bean) {
    bean.update().then((BmobUpdated bmobUpdated) {
      setState(() {});
    }).catchError((e) {
      print("修改数据失败：$e");
    });
  }
}
