import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ConfirmBookingPage extends StatefulWidget {
  @override
  _ConfirmBookingPageState createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String messageTitle = "title";
  String notificationAlert = "alert";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (message) async {
        setState(() {
          messageTitle = message["notification"]["title"];
          notificationAlert = "New Notification Alert";
        });
      },
      onResume: (message) async {
        setState(() {
          messageTitle = message["notification"]["title"];
          notificationAlert = "Application opened from Notification";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(messageTitle), Text(notificationAlert)],
          ),
        ),
      ),
    );
  }
}
