import 'package:easy_travel/screens/registervehicles/registervehicle.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/screens/getvehicles/homepage.dart';
import 'package:easy_travel/screens/userprofile.dart';

class NavBarPage extends StatefulWidget {
  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int _currentIndex = 0;
  //list of stateful classes which are called when nav bars are clicked
  final List<Widget> _children = [
    HomePage(),
    VehicleRegistrationPage(),
    UserProfile(),
  ];

//void method to set the current page index
  void onBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            iconSize: 32,
            backgroundColor: Colors.white,
            onTap: onBarTapped,
            currentIndex: _currentIndex,
            elevation: 5,
            selectedItemColor: Color.fromRGBO(255, 180, 180, 1),
            unselectedItemColor: Color.fromRGBO(190, 190, 190, 1),
            //setting the items of bottom navigation bar
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.car_rental),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ]),
      ),
    );
  }
}
