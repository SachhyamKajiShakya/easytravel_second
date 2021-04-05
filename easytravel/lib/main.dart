import 'package:easy_travel/screens/bookings/confirmbooking.dart';
import 'package:easy_travel/screens/bookings/confirmlongbooking.dart';
import 'package:easy_travel/screens/bookings/payment.dart';
import 'package:easy_travel/screens/userAuthentication/login.dart';
import 'package:easy_travel/screens/userAuthentication/phoneNumber.dart';
import 'package:easy_travel/services/fcmservices.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          headline1: TextStyle(
              fontFamily: 'Roboto', fontSize: 23, color: Colors.black),
          headline2: TextStyle(
              fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
          headline3: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          headline4: TextStyle(
              fontFamily: 'Roboto', fontSize: 18, color: Colors.black),
          headline5: TextStyle(fontSize: 25),
          bodyText1: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Color.fromRGBO(100, 100, 100, 1)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _notificationTrigger();
  }

  void _notificationTrigger() {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print(message);
      },
      onResume: (message) async {
        if (message["data"]["category"] == 'Short Travel') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConfirmBookingPage(
                        bookingid: message["data"]["booking_id"],
                      )));
        } else if (message["data"]["category"] == 'Long Travel') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConfirmLongBooking(
                      bookingid: message["data"]["booking_id"])));
        } else if (message["data"]["screen"] == "payment") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaymentGateway()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('images/wallpaper-iphone-White-256.jpg'),
                        fit: BoxFit.contain)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [buildHeader(context)],
                    ),
                    SizedBox(height: 500),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: buildButton('Sign Up', 300),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PhoneNumberPage()));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: buildButton('Sign In', 300),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
