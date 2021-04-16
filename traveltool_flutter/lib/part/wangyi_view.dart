import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:traveltool_flutter/config/global.dart';
import 'package:traveltool_flutter/model/wangyi_model.dart';
import 'package:traveltool_flutter/utils/dio_util.dart';
import 'package:traveltool_flutter/utils/toast_util.dart';

class WangyiView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WangyiViewState();
}

class _WangyiViewState extends State<WangyiView> {
  List<Result> _wangyiResultList = [];
  int i = 1;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getNews(i.toString(), refresh: true);
  }

  /// 获取网易新闻
  void getNews(String page, {bool refresh}) async {
    DioUtil().requset(Global.WANGYI_URL, Global.news,
        params: {"page": page, "count": "20"}).then((result) {
      if (refresh && _wangyiResultList.length > 0) {
        _wangyiResultList.clear();
      }
      _wangyiResultList.addAll(wangyiModelFromJson(result.toString()).result);
      i++;
      setState(() {});
    }).catchError((error) {
      ToastUtil.instance.show("请求失败！");
    });
  }

  ///刷新
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    getNews(i.toString(), refresh: true);
    _refreshController.refreshCompleted();
  }

  ///加载更多
  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    getNews(i.toString(), refresh: false);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("loading...");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("加载失败！点击重试！");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("释放以加载更多");
              } else {
                body = Text("no more");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemCount:
                (_wangyiResultList == null) ? 0 : _wangyiResultList.length,
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
                                imageUrl: _wangyiResultList[position].image,
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
                                      _wangyiResultList[position].title,
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
                                                _wangyiResultList[position]
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
                  onTap: () {
                    Navigator.pushNamed(context, '/WangyiPage',
                        arguments: _wangyiResultList[position]);
                  });
            },
            physics: new AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
          )),
    );
  }
}
