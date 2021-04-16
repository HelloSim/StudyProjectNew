import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static ToastUtil _instance;

  static ToastUtil get instance => ToastUtil();

  ToastUtil._internal();

  factory ToastUtil() {
    if (_instance == null) _instance = ToastUtil._internal();
    return _instance;
  }

  void show(String string) {
    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
