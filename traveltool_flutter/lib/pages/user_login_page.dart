import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveltool_flutter/model/event_bus.dart';
import 'dart:convert' as convert;

import 'package:traveltool_flutter/utils/preference_utils.dart';

class UserLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _unameController?.dispose();
    _pwdController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200.0,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 30.0),
                color: Colors.white,
              ),
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: new Container(
                  child: buildForm(),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget buildForm() {
    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidate: true, //开启自动校验
      child: Column(
        children: <Widget>[
          TextFormField(
              autofocus: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              //键盘回车键的样式
              controller: _unameController,
              decoration: InputDecoration(
                  labelText: "账号", hintText: "您的账号", icon: Icon(Icons.person)),
              validator: (v) {
                // 校验用户名
                return v.trim().length > 0 ? null : "账号不能为空";
              }),
          TextFormField(
              autofocus: false,
              controller: _pwdController,
              decoration: InputDecoration(
                  labelText: "密码", hintText: "您的密码", icon: Icon(Icons.lock)),
              obscureText: true,
              validator: (v) {
                //校验密码
                return v.trim().length > 0 ? null : "密码不能为空";
              }),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    child: Text("登录"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      //在这里不能通过此方式获取FormState，context不对
                      //print(Form.of(context));
                      // 通过_formKey.currentState获取FormState后，调用validate()方法校验用户名密码是否合法，校验通过后再提交数据。
                      if ((_formKey.currentState as FormState).validate()) {
                        //验证通过提交数据
                        BmobUser bmobUser = BmobUser();
                        bmobUser.username = _unameController.value.text;
                        bmobUser.password = _pwdController.value.text;
                        bmobUser.login().then((BmobUser bmobUser) async {
                          await ([
                            PreferenceUtils.instance
                                .saveBool(PreferenceKey.ISLOGIN, true),
                            PreferenceUtils.instance.saveString(
                                PreferenceKey.USERPASSWORD,
                                _pwdController.value.text),
                            PreferenceUtils.instance.saveString(
                                PreferenceKey.USER,
                                convert.jsonEncode(bmobUser.toJson())),
                            eventBus.fire(IsLogin(true))
                          ]);
                          Navigator.pop(context, bmobUser);
                        }).catchError((e) {
                          showError(context, BmobError.convert(e).error);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
