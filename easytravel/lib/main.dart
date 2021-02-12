import 'package:easy_travel/screens/userauthentication/login.dart';
import 'package:easy_travel/screens/userauthentication/signup.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
              fontFamily: 'Calibri', fontSize: 25, color: Colors.black),
          headline2: TextStyle(
              fontSize: 16, fontFamily: 'Cambria', color: Colors.black),
          headline3: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          headline4: TextStyle(
              fontFamily: 'Calibri', fontSize: 20, color: Colors.black),
          headline5: TextStyle(fontSize: 25),
          bodyText1: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Calibri',
            fontSize: 20,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
              fontFamily: 'Calibri', fontSize: 16, color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [buildHeader(context)],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  child: Image(
                      image: AssetImage(
                          'images/93fa114f2edc9fd0328c2cc89491f016_best-friends-car-illustrations-royalty-free-vector-graphics-_612-550.jpeg')),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: buildButton('Sign Up'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: buildButton('Sign In'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                )
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
