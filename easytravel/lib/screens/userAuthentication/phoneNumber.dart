import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/userAuthentication/otp.dart';
import 'package:easy_travel/services/api.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  TextEditingController _phoneController = TextEditingController();
  bool _autovalidate = false;
  final _formKey = GlobalKey<FormState>();
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined,
                  size: 22, color: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              }),
          centerTitle: true,
          title: Text(
            'Phone Verification',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Roboto', fontSize: 20),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: ListView(
            children: [
              Center(child: buildSubHeader("What's your phone number?")),
              SizedBox(height: 35),
              Center(
                child: Text(
                  'Make sure you get a SMS to this number',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  'so that you receive the code sent to this number',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Form(
                autovalidate: _autovalidate,
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    contactField(context, 'Contact', 'your contact number',
                        _onTap, null, null, _phoneController, 370),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => OTP(
                        //               phoneNumber:
                        //                   '+977' + _phoneController.text,
                        //             )));
                        enterPhone('+977' + _phoneController.text, context);
                      } else {
                        setState(() {
                          _autovalidate = true;
                        });
                      }
                    },
                    child: buildButton('Continue', 150),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
