import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:traveltool_flutter/config/global.dart';
import 'package:traveltool_flutter/model/bus_location_model.dart';
import 'package:traveltool_flutter/utils/dio_util.dart';

class BusRouteView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BusRouteViewState();
}

class _BusRouteViewState extends State<BusRouteView> {
  TextEditingController _startController = new TextEditingController();
  TextEditingController _endController = new TextEditingController();

  List<Tip> _busLocationList = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: Column(
          children: <Widget>[
            TextField(
                controller: _startController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    labelText: '起始站',
                    prefixIcon: Icon(Icons.train_sharp)),
                onChanged: (text) {
                  DioUtil()
                      .requset(Global.OPSITION_URL, Global.inputtips,
                          params: getMap(text))
                      .then((value) {
                    print(value);
                  }).catchError((error) {
                    print(error);
                  });
                }),
            TextField(
                controller: _endController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    labelText: '终点站',
                    prefixIcon: Icon(Icons.train_sharp)),
                onChanged: (text) {
                  DioUtil()
                      .requset(Global.OPSITION_URL, Global.inputtips,
                          params: getMap(text))
                      .then((value) {
                    print(value);
                  }).catchError((error) {
                    print(error);
                  });
                }),
            Container(
              margin: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border(
                    bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
              ),
              child: FlatButton(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text(
                  "换乘方案",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ));
    });
  }

  Map<String, dynamic> getMap(String text) {
    Map<String, dynamic> params = {
      "s": "rsv3",
      "key": "ceb54024fae4694f734b1006e8dc8324",
      "city": "0756",
      "citylimit": "false",
      "callback": "",
      "platform": "JS",
      "logversion": "2.0",
      "sdkversion": "1.3",
      "appname": "http://www.zhbuswx.com/busline/BusQuery.html?v=2.01#/",
      "csid": "759CACE2-2197-4E0A-ADCB-1456B16775DA",
      "keywords": text,
    };
    return params;
  }
}
