import 'dart:async';
import 'package:data_plugin/bmob/bmob_sms.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_sent.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;

import 'package:traveltool_flutter/utils/preference_utils.dart';
import 'package:traveltool_flutter/utils/toast_util.dart';

class UserUpdatePasswordForCodePage extends StatefulWidget {
  @override
  State<UserUpdatePasswordForCodePage> createState() =>
      _UserUpdatePasswordForCodePageState();
}

class _UserUpdatePasswordForCodePageState
    extends State<UserUpdatePasswordForCodePage> {
  BmobUser _bmobUser;

  bool _isButtonEnable = true; //按钮状态  是否可点击
  String _buttonText = '发送验证码'; //初始文本
  int _count = 60; //初始倒计时时间
  Timer _timer; //倒计时的计时器
  TextEditingController _mController = TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void dispose() {
    _timer?.cancel(); //销毁计时器
    _timer = null;
    _mController?.dispose();
    _pwdController?.dispose();
    super.dispose();
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
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  Text(
                    '验证码',
                    style: TextStyle(fontSize: 16, color: Color(0xff333333)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: TextFormField(
                          maxLines: 1,
                          onSaved: (value) {},
                          controller: _mController,
                          textAlign: TextAlign.left,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          decoration: InputDecoration(
                            hintText: ('填写验证码'),
                            hintStyle: TextStyle(
                              color: Color(0xff999999),
                              fontSize: 16,
                            ),
                            alignLabelWithHint: true,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          validator: (v) {
                            //校验验证码
                            return v.trim().length == 6 ? null : "验证码错误";
                          }),
                    ),
                  ),
                  Container(
                    width: 120,
                    child: FlatButton(
                      disabledColor: Colors.grey.withOpacity(0.1),
                      //按钮禁用时的颜色
                      disabledTextColor: Colors.white,
                      //按钮禁用时的文本颜色
                      textColor: _isButtonEnable
                          ? Colors.white
                          : Colors.black.withOpacity(0.2),
                      //文本颜色
                      color: _isButtonEnable
                          ? Color(0xff44c5fe)
                          : Colors.grey.withOpacity(0.1),
                      //按钮的颜色
                      splashColor: _isButtonEnable
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                      shape: StadiumBorder(side: BorderSide.none),
                      onPressed: () {
                        setState(() {
                          _buttonClickListen();
                        });
                      },
                      child: Text(
                        '$_buttonText',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
                autofocus: false,
                controller: _pwdController,
                decoration:
                    InputDecoration(labelText: "新密码", hintText: "设置新密码"),
                obscureText: true,
                validator: (v) {
                  //校验密码
                  return v.trim().length > 0 ? null : "密码不能为空";
                }),
            Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      child: Text("修改"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          ///手机号码+短信验证码重置密码
                          _bmobUser
                              .requestPasswordResetBySmsCode(
                                  _mController.value.text)
                              .then((BmobHandled bmobHandled) {
                            ToastUtil.instance.show("修改成功！");
                            Navigator.pop(context);
                          }).catchError((e) {
                            showError(context, BmobError.convert(e).error);
                          });
                        }
                      },
                    ),
                  )
                ])),
          ],
        ),
      ),
    );
  }

  void _buttonClickListen() {
    setState(() {
      if (_isButtonEnable) {
        //当按钮可点击时
        ///发送短信验证码：需要手机号码
        BmobSms bmobSms = BmobSms();
        bmobSms.template = "";
        bmobSms.mobilePhoneNumber = _bmobUser.mobilePhoneNumber;
        bmobSms.sendSms().then((BmobSent bmobSent) {
          _isButtonEnable = false; //按钮状态标记
          _initTimer();
          return null; //返回null按钮禁止点击
        }).catchError((e) {
          showError(context, BmobError.convert(e).error);
        });
      } else {
        //当按钮不可点击时
        return null; //返回null按钮禁止点击
      }
    });
  }

  void _initTimer() {
    _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _count--;
      setState(() {
        if (_count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          _isButtonEnable = true; //按钮可点击
          _count = 60; //重置时间
          _buttonText = '发送验证码'; //重置按钮文本
        } else {
          _buttonText = '重新发送($_count)'; //更新文本内容
        }
      });
    });
  }
}
