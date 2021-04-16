import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:traveltool_flutter/utils/preference_utils.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  BmobUser _bmobUser;

  @override
  void initState() {
    super.initState();
    _judgeLogin();
  }

  @override
  Widget build(BuildContext context) {
    PreferenceUtils.instance.getString(PreferenceKey.USER).then(
        (value) => _bmobUser = BmobUser.fromJson(convert.jsonDecode(value)));
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text("用户详情"),
      ),
      body: Column(children: <Widget>[
        ListTile(
          leading: Icon(Icons.verified),
          title: Text(_bmobUser.username),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.smartphone),
          title: Text(_bmobUser.mobilePhoneNumber),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.enhanced_encryption),
          title: Text("******"),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text("修改密码"),
                    children: <Widget>[
                      FlatButton(
                          child: Text("通过密码修改"),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/UserUpdatePasswordForOldPage');
                          }),
                      FlatButton(
                          child: Text("通过验证码修改"),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/UserUpdatePasswordForCodePage');
                          }),
                    ],
                  );
                });
          },
        ),
      ]),
    ));
  }

  ///读取用户信息，刷新显示
  Future<void> _judgeLogin() async {
    await PreferenceUtils.instance
        .getString(PreferenceKey.USERNAME)
        .then((value) => null);
    await PreferenceUtils.instance
        .getString(PreferenceKey.USERPASSWORD)
        .then((value) => null);
    await PreferenceUtils.instance
        .getString(PreferenceKey.USERPHONENUMBER)
        .then((value) => null);
    setState(() {});
  }
}
