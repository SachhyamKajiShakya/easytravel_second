import 'dart:ui';
import 'package:easy_travel/screens/profile/bookingDetails.dart';
import 'package:easy_travel/screens/profile/editVehicle.dart';
import 'package:easy_travel/screens/profile/futureBooking.dart';
import 'package:easy_travel/services/api.dart';
import 'package:easy_travel/services/getbooking.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';

import '../profilewidgets.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String userName;
  String userEmail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    buildAvatar(),
                    SizedBox(height: 30),
                    buildSubHeader(snapshot.data["name"]),
                    SizedBox(height: 30),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          labelPadding: EdgeInsets.all(5),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue,
                          ),
                          labelColor: Colors.white,
                          labelStyle: TextStyle(fontSize: 16),
                          unselectedLabelColor: Color.fromRGBO(80, 80, 80, 1),
                          unselectedLabelStyle: TextStyle(fontSize: 14),
                          tabs: [
                            Tab(
                              text: 'Booking History',
                            ),
                            Tab(
                              text: 'Future Bookings',
                            ),
                            Tab(
                              text: 'Posted Vehicles',
                            ),
                            Tab(
                              text: 'Booking Request',
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          buildBookingHistory(),
                          buildFutureBookings(),
                          buildPostedVehicles(),
                          buildRequestedBookings(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        drawer: buildDrawer(context),
      ),
    );
  }

  Widget buildBookingHistory() {
    return FutureBuilder(
      future: getPastBookings(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return buildUserBodyCard(
                  snapshot,
                  index,
                  context,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingDetails(
                                snapshot: snapshot,
                                index: index,
                              ))));
            },
          );
        }
      },
    );
  }

  Widget buildFutureBookings() {
    return FutureBuilder(
      future: getFutureBookings(),
      builder: (context, snapshot) {
        // print(snapshot.data);
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return buildFutureBookingBodyCard(
                snapshot,
                index,
                context,
              );
            },
          );
        }
      },
    );
  }

  Widget buildPostedVehicles() {
    return FutureBuilder(
      future: getPostedVehicles(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return buildPostedVehiclesBodyCard(
                snapshot,
                index,
                context,
              );
            },
          );
        }
      },
    );
  }

  Widget buildRequestedBookings() {
    return FutureBuilder(
      future: getRequestedBooking(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return buildUserBodyCard(
                  snapshot,
                  index,
                  context,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingDetails(
                                snapshot: snapshot,
                                index: index,
                              ))));
            },
          );
        }
      },
    );
  }
}
