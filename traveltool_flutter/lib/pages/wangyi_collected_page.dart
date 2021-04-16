import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:traveltool_flutter/model/wangyi_collect_model.dart';
import 'package:traveltool_flutter/model/wangyi_model.dart';
import 'package:traveltool_flutter/utils/preference_utils.dart';

class WangyiCollectedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WangyiCollectedPageState();
}

class _WangyiCollectedPageState extends State<WangyiCollectedPage> {
  BmobUser _bmobUser;
  List<NewsBean> _newsBeanList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (_bmobUser != null) getCollected(_bmobUser);
    });
  }

  ///查询数据
  Future<void> getCollected(BmobUser bmobUser) async {
    BmobQuery<NewsBean> query = BmobQuery();
    query.addWhereEqualTo("user", _bmobUser);
    query.queryObjects().then((data) {
      List<NewsBean> list = data.map((i) => NewsBean.fromJson(i)).toList();
      setState(() {
        _newsBeanList.clear();
        _newsBeanList.addAll(list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    PreferenceUtils.instance.getString(PreferenceKey.USER).then((value) {
      _bmobUser = BmobUser.fromJson(convert.jsonDecode(value));
    });
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text("收藏"),
            ),
            body: ListView.builder(
              itemCount: (_newsBeanList == null) ? 0 : _newsBeanList.length,
              itemBuilder: (BuildContext context, int position) {
                return new GestureDetector(
                    child: Column(
                      children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Expanded(
                              child: Container(
                                child: CachedNetworkImage(
                                  imageUrl: _newsBeanList[position].image,
                                  placeholder: (context, url) => new Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                                alignment: FractionalOffset.center,
                              ),
                              flex: 1,
                            ),
                            new Expanded(
                              child: Container(
                                height: 70.0,
                                margin:
                                    new EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      child: new Text(
                                        _newsBeanList[position].title,
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      alignment: FractionalOffset.topLeft,
                                    ),
                                    new Expanded(
                                      child: new Container(
                                        margin: new EdgeInsets.fromLTRB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                              child: new Text(
                                                  _newsBeanList[position]
                                                      .passtime
                                                      .toString(),
                                                  style: new TextStyle(
                                                      fontSize: 12.0)),
                                              alignment:
                                                  FractionalOffset.bottomLeft,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        new Divider(), //分割线
                      ],
                    ),
                    behavior: HitTestBehavior.opaque, //解决点击item只能在text上生效的问题
                    onTap: () async {
                      Result result = new Result(
                          path: _newsBeanList[position].path,
                          image: _newsBeanList[position].image,
                          title: _newsBeanList[position].title,
                          passtime: _newsBeanList[position].passtime);
                      await Navigator.pushNamed(context, '/WangyiPage',
                          arguments: result);
                      getCollected(_bmobUser);
                    });
              },
              physics: new AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
            )));
  }
}
