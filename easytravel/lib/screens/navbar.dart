import 'package:easy_travel/screens/getVehicles/homepage.dart';
import 'package:easy_travel/screens/registervehicles/registervehicle.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/screens/profile/userprofile.dart';

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
            iconSize: 26,
            backgroundColor: Color.fromRGBO(254, 254, 254, 1),
            onTap: onBarTapped,
            currentIndex: _currentIndex,
            elevation: 5,
            selectedItemColor: Colors.white,
            unselectedItemColor: Color.fromRGBO(190, 190, 190, 1),
            //setting the items of bottom navigation bar
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == 0
                            ? Colors.redAccent
                            : Colors.white),
                    child: Icon(Icons.home)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == 1
                            ? Colors.redAccent
                            : Colors.white),
                    child: Icon(Icons.car_rental)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == 2
                            ? Colors.redAccent
                            : Colors.white),
                    child: Icon(Icons.person)),
                label: '',
              ),
            ]),
      ),
    );
  }
}
