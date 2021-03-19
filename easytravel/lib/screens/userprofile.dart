import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String messageTitle = "title";
  String notificationAlert = "alert";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
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
