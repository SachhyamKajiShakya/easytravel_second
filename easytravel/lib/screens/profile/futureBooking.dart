import 'package:flutter/material.dart';

import '../../constants.dart';

class FutureBooking extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final index;

  const FutureBooking({Key key, this.snapshot, this.index}) : super(key: key);
  @override
  _FutureBookingState createState() => _FutureBookingState();
}

class _FutureBookingState extends State<FutureBooking> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(230, 230, 230, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(230, 230, 230, 1),
          elevation: 0,
          centerTitle: true,
          title: buildSubHeader('Booking Details'),
        ),
        body: ListView(children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildData('Driver Name',
                      widget.snapshot.data[widget.index]["driver_name"]),
                  SizedBox(height: 20),
                  _buildData('Driver Contact',
                      widget.snapshot.data[widget.index]["driver_contact"]),
                  SizedBox(height: 20),
                  _buildData(
                      'Vehicle',
                      widget.snapshot.data[widget.index]["vehicle_brand"] +
                          ' ' +
                          widget.snapshot.data[widget.index]["vehicle_model"]),
                  SizedBox(height: 20),
                  _buildData('Pickup Date',
                      widget.snapshot.data[widget.index]["pick_up_date"]),
                  SizedBox(height: 20),
                  _buildData('Pickup Time',
                      widget.snapshot.data[widget.index]["pick_up_time"]),
                  SizedBox(height: 20),
                  _buildData(
                      'Pickup Location',
                      widget.snapshot.data[widget.index]["pick_up_province"]
                              .toString() +
                          ',' +
                          widget.snapshot.data[widget.index]
                              ["pick_up_district"] +
                          ' ' +
                          widget.snapshot.data[widget.index]["pick_up_city"] +
                          ' ' +
                          widget.snapshot.data[widget.index]["pick_up_street"]),
                  SizedBox(height: 20),
                  _buildData(
                      'Destination Location',
                      widget.snapshot.data[widget.index]["destination_province"]
                              .toString() +
                          ',' +
                          widget.snapshot.data[widget.index]
                              ["destination_district"] +
                          ' ' +
                          widget.snapshot.data[widget.index]
                              ["destination_city"] +
                          ' ' +
                          widget.snapshot.data[widget.index]
                              ["destination_street"]),
                  SizedBox(height: 20),
                  _buildData(
                      'Booked For',
                      widget.snapshot.data[widget.index]["number_of_days"]
                              .toString() +
                          ' days'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: buildButton('Done', 200),
          ),
        ]),
      ),
    );
  }

  // a widget function to build rows of content
  Widget _buildData(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
