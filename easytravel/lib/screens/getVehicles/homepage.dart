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
                    color: Colors.black, fontFamily: 'Cambria', fontSize: 28),
              ),
            ),
            backgroundColor: Color.fromRGBO(254, 254, 254, 100),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(100, 80),
              child: Container(
                height: 36,
                margin:
                    EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
                child: TabBar(
                  labelColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 18),
                  unselectedLabelStyle: TextStyle(fontSize: 16),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  unselectedLabelColor: Colors.black,
                  indicator: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tabs: [
                    //seeting the tabs
                    Tab(text: 'Short Travel'),
                    Tab(text: 'Long Travel'),
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

// // widget method to build tab items
//   Widget _buildTab(String text) {
//     return Container(
//         child: Align(
//       alignment: Alignment.center,
//       child:
//           Text('$text', style: TextStyle(fontSize: 16, fontFamily: 'Roboto')),
//     ));
//   }
// }
}
