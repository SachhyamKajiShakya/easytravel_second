import 'package:easy_travel/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:easy_travel/services/getbooking.dart';

class ConfirmLongBooking extends StatelessWidget {
  // booking id obtained from the notification
  final String bookingid;

  const ConfirmLongBooking({Key key, this.bookingid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(230, 230, 230, 1),
          elevation: 0,
          centerTitle: true,
          title: buildSubHeader('Requested Booking'),
        ),
        backgroundColor: Color.fromRGBO(230, 230, 230, 1),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: FutureBuilder(
            future: getBooking(bookingid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) {
                  print(snapshot.data);
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildData('Customer Name',
                                  snapshot.data["customer_name"], snapshot),
                              SizedBox(height: 20),
                              _buildData('Customer Contact',
                                  snapshot.data["customer_contact"], snapshot),
                              SizedBox(height: 20),
                              _buildData('Driver Name',
                                  snapshot.data["driver_name"], snapshot),
                              SizedBox(height: 20),
                              _buildData('Driver Contact',
                                  snapshot.data["driver_contact"], snapshot),
                              SizedBox(height: 20),
                              _buildData(
                                  'Vehicle',
                                  snapshot.data["vehicle_brand"] +
                                      ' ' +
                                      snapshot.data["vehicle_model"],
                                  snapshot),
                              SizedBox(height: 20),
                              _buildData('Pickup Date',
                                  snapshot.data["pick_up_date"], snapshot),
                              SizedBox(height: 20),
                              _buildData('Pickup Time',
                                  snapshot.data["pick_up_time"], snapshot),
                              SizedBox(height: 20),
                              _buildData(
                                  'Pickup Location',
                                  snapshot.data["pick_up_province"].toString() +
                                      ',' +
                                      snapshot.data["pick_up_district"] +
                                      ' ' +
                                      snapshot.data["pick_up_city"] +
                                      ' ' +
                                      snapshot.data["pick_up_street"],
                                  snapshot),
                              SizedBox(height: 20),
                              _buildData(
                                  'Destination Location',
                                  snapshot.data["destination_province"]
                                          .toString() +
                                      ',' +
                                      snapshot.data["destination_district"] +
                                      ' ' +
                                      snapshot.data["destination_city"] +
                                      ' ' +
                                      snapshot.data["destination_street"],
                                  snapshot),
                              SizedBox(height: 20),
                              _buildData(
                                  'Booked For',
                                  snapshot.data["number_of_days"].toString() +
                                      ' days',
                                  snapshot),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          FlatButton(
                              child: buildButton('Confirm', 150),
                              onPressed: () {
                                sendConfirmnotification(bookingid, context);
                              }),
                          FlatButton(
                            onPressed: () {
                              sendCancelnotification(bookingid, context);
                            },
                            child: buildButton('Deny', 150),
                          ),
                        ],
                      ),
                      SizedBox(height: 20)
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

// a widget function to build rows of content
  Widget _buildData(String title, String body, AsyncSnapshot snapshot) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(
                  color: Color.fromRGBO(160, 160, 160, 1),
                  fontSize: 17,
                  fontFamily: 'Roboto',
                )),
          ],
        ),
        SizedBox(height: 3),
        Row(
          children: [
            Text(body,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: Colors.black,
                ))
          ],
        ),
      ],
    );
  }
}
