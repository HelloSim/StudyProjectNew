import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusRealTimeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BusRealTimeViewState();
}

class _BusRealTimeViewState extends State<BusRealTimeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
            enabled: false,
            controller: TextEditingController(),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0), labelText: '路线名称'),
            onChanged: (text) {}),
        ListView.builder(
          itemCount: 0,
          itemBuilder: (BuildContext context, int position) {
            return new GestureDetector(
                child: Column(
                  children: <Widget>[
                    new Text(""),
                    new Divider(), //分割线
                  ],
                ),
                behavior: HitTestBehavior.opaque, //解决点击item只能在text上生效的问题
                onTap: () {
                });
          },
          physics: new AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ],
    );
  }
}
