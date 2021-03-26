import 'package:easy_travel/services/getbooking.dart';
import 'package:flutter/material.dart';

class ConfirmBookingPage extends StatelessWidget {
  final String bookingid;

  const ConfirmBookingPage({Key key, this.bookingid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: FutureBuilder(
            future: getBooking(bookingid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(snapshot.data["customer_name"]),
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
}
