import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:traveltool_flutter/model/wangyi_collect_model.dart';
import 'dart:convert' as convert;

import 'package:traveltool_flutter/model/wangyi_model.dart';
import 'package:traveltool_flutter/utils/preference_utils.dart';
import 'package:traveltool_flutter/utils/toast_util.dart';

class WangyiPage extends StatefulWidget {
  final Result arguments;

  const WangyiPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WangyiPageState(this.arguments);
}

class _WangyiPageState extends State<WangyiPage> {
  _WangyiPageState(this._arguments);

  bool _flag = true; //是否显示加载动画
  Result _arguments; //传递过来的实体
  bool _isLogIn = false; //是否登录
  bool _collected = false; //是否收藏
  NewsBean _newsBean = NewsBean(); //后台收藏的实体

  @override
  void initState() {
    super.initState();
    //延时3s操作
    Future.delayed(Duration(seconds: 1), () {
      if (_isLogIn) {
        _newsBean.image = _arguments.image;
        _newsBean.title = _arguments.title;
        _newsBean.path = _arguments.path;
        _newsBean.passtime = _arguments.passtime;
        PreferenceUtils.instance.getString(PreferenceKey.USER).then((value) {
          Map<String, dynamic> map = convert.jsonDecode(value);
          String objectId = map['objectId'];
          _newsBean.user = new BmobUser();
          _newsBean.user.objectId = objectId;
          _query(_newsBean.user, _newsBean.title);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    PreferenceUtils.instance
        .getBool(PreferenceKey.ISLOGIN, false)
        .then((index) {
      _isLogIn = index;
    });
    return Container(
        child: Scaffold(
      appBar: AppBar(
          title: this._flag ? _getMoreWidget() : Text("详情"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                  _collected ? Icons.local_offer : Icons.local_offer_outlined),
              onPressed: () {
                if (_isLogIn) {
                  if (_collected) {
                    _delete(_newsBean);
                  } else {
                    _save(_newsBean);
                  }
                } else {
                  ToastUtil.instance.show("收藏失败：未登录！");
                }
              },
            ),
          ]),
      body: Column(children: <Widget>[
        Expanded(
            child: InAppWebView(
                initialUrl: _arguments.path,
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  if ((progress / 100) > 0.999) {
                    setState(() {
                      this._flag = false;
                    });
                  }
                }))
      ]),
    ));
  }

  ///查询数据
  _query(var user, String title) async {
    BmobQuery<NewsBean> query = BmobQuery();
    query.addWhereEqualTo("user", user);
    query.addWhereEqualTo("title", title);
    await query.queryObjects().then((data) {
      _collected = data.length > 0;
    }).catchError((e) {
      _collected = false;
    });
  }

  ///保存数据
  void _save(NewsBean bean) {
    bean.save().then((BmobSaved bmobSaved) {
      _collected = true;
      setState(() {});
    }).catchError((e) {
      ToastUtil.instance.show("收藏失败：$e");
    });
  }

  ///删除数据
  _delete(NewsBean bean) {
    BmobQuery<NewsBean> query = BmobQuery();
    query.addWhereEqualTo("user", bean.user);
    query.addWhereEqualTo("title", bean.title);
    query.queryObjects().then((data) {
      List<NewsBean> newsBean = data.map((i) => NewsBean.fromJson(i)).toList();
      newsBean[0].delete().then((value) {
        _collected = false;
        setState(() {});
      }).catchError((e) {
        ToastUtil.instance.show("取消收藏失败：$e");
      });
    });
  }

  /// 加载状态
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }
}
