import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'config/global.dart';
import 'model/event_bus.dart';
import 'pages/record_month_page.dart';
import 'pages/user_info_page.dart';
import 'pages/user_login_page.dart';
import 'pages/user_update_password_page_for_code.dart';
import 'pages/user_update_password_page_for_old.dart';
import 'pages/wangyi_collected_page.dart';
import 'pages/wangyi_page.dart';
import 'part/bus_view.dart';
import 'part/record_view.dart';
import 'part/wangyi_view.dart';
import 'utils/preference_utils.dart';
import 'dart:convert' as convert;

void main() {
  Bmob.initMasterKey(Global.Bmob_URL, Global.Bmob_APPLICATION_ID,
      Global.Bmob_REST_API_KEY, Global.Bmob_MASTER_KEY);
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      routes: <String, WidgetBuilder>{
        '/UserLoginPage': (context) => UserLoginPage(),
        '/UserInfoPage': (context) => UserInfoPage(),
        '/UserUpdatePasswordForCodePage': (context) =>
            UserUpdatePasswordForCodePage(),
        '/UserUpdatePasswordForOldPage': (context) =>
            UserUpdatePasswordForOldPage(),
        '/WangyiPage': (context) => WangyiPage(),
        '/WangyiCollectedPage': (context) => WangyiCollectedPage(),
        '/RecordMonthView': (context) => RecordMonthView(),
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  BmobUser _bmobUser = new BmobUser();
  bool _isLogIn = false;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _bodyViews = [
    WangyiView(),
    BusView(),
    RecordView(),
  ];

  @override
  void initState() {
    super.initState();
    _judgeLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_selectedIndex == 0
              ? "网易"
              : _selectedIndex == 1
                  ? "出行"
                  : "打卡"),
          actions: <Widget>[
            Offstage(
              offstage: _selectedIndex != 2,
              child: IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  eventBus.fire(More(true));
                },
              ),
            ),
          ]),
      drawer: _drawer,
      body: _bodyViews[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("首页"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train),
            title: Text("出行"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.where_to_vote),
            title: Text("打卡"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
      ),
    );
  }

  get _drawer => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                //背景图片
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    "images/user/splash.jpg",
                  ),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(_isLogIn
                    ? "images/user/photo.jpg"
                    : "images/user/no_login.png"),
              ),
              accountName: InkWell(
                  child: Text(
                    (!_isLogIn)
                        ? ""
                        : (_bmobUser.username == null
                            ? ""
                            : _bmobUser.username),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    if (_isLogIn) {
                      Navigator.pushNamed(context, '/UserInfoPage');
                    }
                  }),
              accountEmail: Text((!_isLogIn)
                  ? ""
                  : (_bmobUser.email == null ? "" : _bmobUser.email)),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(_isLogIn ? "退出登录" : "登录"),
              onTap: () async {
                if (_isLogIn) {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text("确定要退出吗？"),
                          actions: <Widget>[
                            FlatButton(
                                child: Text("取消"),
                                onPressed: () => Navigator.pop(context)),
                            FlatButton(
                                child: Text("确定"),
                                onPressed: () async {
                                  await ([
                                    PreferenceUtils.instance
                                        .saveBool(PreferenceKey.ISLOGIN, false),
                                    PreferenceUtils.instance.saveString(
                                        PreferenceKey.USERPASSWORD, ""),
                                    PreferenceUtils.instance
                                        .saveString(PreferenceKey.USER, ""),
                                    eventBus.fire(IsLogin(false))
                                  ]);
                                  Navigator.pop(context);
                                  _judgeLogin();
                                })
                          ],
                        );
                      });
                } else {
                  _login();
                }
                setState(() {});
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text("收藏"),
              onTap: () {
                if (_isLogIn) {
                  Navigator.pushNamed(context, '/WangyiCollectedPage');
                }
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("设置"),
              onTap: () {},
            ),
          ],
        ),
      );

  ///根据sp储存的信息判断当前登录状态
  void _judgeLogin() async {
    await PreferenceUtils.instance
        .getBool(PreferenceKey.ISLOGIN, false)
        .then((index) {
      _isLogIn = index;
      if (_isLogIn) {
        PreferenceUtils.instance
            .getString(PreferenceKey.USERPASSWORD)
            .then((value) => _bmobUser.password = value);
        PreferenceUtils.instance.getString(PreferenceKey.USER).then((value) =>
            _bmobUser = BmobUser.fromJson(convert.jsonDecode(value)));
        _bmobUser.login();
      }
    });
    setState(() {});
  }

  ///跳转登录页登录
  void _login() async {
    _bmobUser = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new UserLoginPage()),
    );
    await PreferenceUtils.instance
        .getBool(PreferenceKey.ISLOGIN, false)
        .then((index) {
      _isLogIn = index;
    });
    setState(() {});
  }
}
