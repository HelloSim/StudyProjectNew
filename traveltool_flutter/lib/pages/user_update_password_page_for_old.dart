import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:traveltool_flutter/utils/preference_utils.dart';

class UserUpdatePasswordForOldPage extends StatefulWidget {
  @override
  State<UserUpdatePasswordForOldPage> createState() =>
      _UserUpdatePasswordForOldPageState();
}

class _UserUpdatePasswordForOldPageState
    extends State<UserUpdatePasswordForOldPage> {
  BmobUser _bmobUser;

  TextEditingController _oldPwdController = TextEditingController();
  TextEditingController _newPwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _oldPwdController?.dispose();
    _newPwdController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PreferenceUtils.instance.getString(PreferenceKey.USER).then(
        (value) => _bmobUser = BmobUser.fromJson(convert.jsonDecode(value)));
    return Scaffold(
      appBar: AppBar(
        title: Text("修改密码"),
      ),
      body: Form(
          key: _formKey, //设置globalKey，用于后面获取FormState
          autovalidate: false, //开启自动校验
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    autofocus: false,
                    controller: _oldPwdController,
                    decoration:
                        InputDecoration(labelText: "原密码", hintText: "输入原密码"),
                    obscureText: true,
                    validator: (v) {
                      //校验密码
                      return v.trim().length > 0 ? null : "密码不能为空";
                    }),
                TextFormField(
                    autofocus: false,
                    controller: _newPwdController,
                    decoration:
                        InputDecoration(labelText: "新密码", hintText: "设置新密码"),
                    obscureText: true,
                    validator: (v) {
                      //校验密码
                      return v.trim().length > 0 ? null : "密码不能为空";
                    }),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 15.0, right: 15.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(15.0),
                          child: Text("修改"),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            if ((_formKey.currentState as FormState)
                                .validate()) {
                              ///旧密码重置密码
                              _bmobUser
                                  .updateUserPassword(
                                      _oldPwdController.value.text,
                                      _newPwdController.value.text)
                                  .then((BmobHandled bmobHandled) {
                                showSuccess(context, "修改成功");
                              }).catchError((e) {
                                showError(context, BmobError.convert(e).error);
                              });
                            }
                          },
                        ),
                      )
                    ]))
              ])),
    );
  }
}
