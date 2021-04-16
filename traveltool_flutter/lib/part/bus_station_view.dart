import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusStationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
          enabled: false,
          controller: TextEditingController(),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0), labelText: '站点名称')),
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border(
              //每条列表项底部加一个边框
              bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
        ),
        // child: FlatButton(
        //   child: Text(
        //     "站点查询",
        //     style: TextStyle(fontSize: 16.0, color: Colors.white),
        //   ),
        //   onPressed: () {},
        // ),
      ),
    ]);
  }
}
