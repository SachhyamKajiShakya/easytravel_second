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
          child: ListView(
            children: [
              Column(
                children: [Text(bookingid)],
              )
            ],
          ),
        ),
      ),
    );
  }
}
