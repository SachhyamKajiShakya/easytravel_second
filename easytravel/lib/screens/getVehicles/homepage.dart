import 'package:flutter/material.dart';
import 'package:easy_travel/screens/getVehicles/firsttab.dart';
import 'package:easy_travel/screens/getVehicles/secondtab.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        //setting default tab controller
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Book Your Ride',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Cambria', fontSize: 35),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(100, 80),
              child: Container(
                height: 36,
                margin: EdgeInsets.only(top: 15, bottom: 10),
                child: TabBar(
                  //adding tabs in the app bar
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    color: Color.fromRGBO(250, 232, 232, 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  tabs: [
                    //seeting the tabs
                    Tab(
                      child: Container(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('Short Travel',
                                style: Theme.of(context).textTheme.headline2)),
                      ),
                    ),
                    Tab(
                      child: Container(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('Long Travel',
                                style: Theme.of(context).textTheme.headline2)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: TabBarView(
            //a widget view that calls the pages when corresponding tabs are clicked
            children: [
              FirstTab(),
              SecondTabPage(),
            ],
          ),
        ),
      ),
    );
  }
}
