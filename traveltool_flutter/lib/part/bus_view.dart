import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'bus_real_time_view.dart';
import 'bus_route_view.dart';
import 'bus_station_view.dart';

class BusView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BusViewState();
}

class _BusViewState extends State<BusView> with SingleTickerProviderStateMixin {
  List _tabs = ["实时公交", "出行路线", "站点查询"];
  TabController _tabController;

  final List<Widget> _bodyViews = [
    BusRealTimeView(),
    BusRouteView(),
    BusStationView(),
  ];

  Widget getBodyView(String string) {
    if (string == "实时公交") {
      return _bodyViews[0];
    } else if (string == "出行路线") {
      return _bodyViews[1];
    } else {
      return _bodyViews[2];
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  final List<Image> _images = [
    //建立了一个图片数组
    Image.asset(
      'images/swiper/photo1.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'images/swiper/photo2.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'images/swiper/photo3.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'images/swiper/photo4.jpg',
      fit: BoxFit.cover,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 175,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return _images[index]; //条目构建函数传入了index,根据index索引到特定图片
          },
          itemCount: _images.length,
          autoplay: true,
          //
          pagination: new SwiperPagination(),
          //页码，通俗讲就是下边的圆点  这些都是控件默认写好的,直接用
          control: new SwiperControl(), //控制器，通俗讲就是两边的箭头
        ),
      ),
      // CarouselSlider(
      //   options: CarouselOptions(height: 200.0),
      //   items: [1, 2, 3, 4, 5].map((i) {
      //     return Builder(
      //       builder: (BuildContext context) {
      //         return Container(
      //           width: MediaQuery.of(context).size.width,
      //           margin: EdgeInsets.symmetric(horizontal: 5.0),
      //           child: Image.asset(images[i - 1], fit: BoxFit.fill),
      //         );
      //       },
      //     );
      //   }).toList(),
      // ),
      TabBar(
        tabs: _tabs.map((text) => Tab(text: text)).toList(),
        controller: _tabController,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black,
        indicatorColor: Colors.transparent,
      ),
      Expanded(
          child: TabBarView(
              controller: _tabController,
              children: _tabs.map((text) {
                return Center(
                  child: getBodyView(text),
                );
              }).toList()))
    ]);
  }
}
