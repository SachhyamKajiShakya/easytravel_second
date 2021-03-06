import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/userAuthentication/otp.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  TextEditingController _phoneController = TextEditingController();
  bool _autovalidate = false;
  final _formKey = GlobalKey<FormState>();
  _enterPhone(String phone) async {
    final http.Response response = await http.post(
      'http://192.168.100.67:8000/api/phoneNumber/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'phone': phone,
        },
      ),
    );
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTP(
                    phoneNumber: phone,
                  )));
    } else {
      throw Exception('Process Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Phone Verification',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Roboto', fontSize: 20),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [buildSubHeader("What's your phone number?")],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Make sure you get a SMS to this number',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'so that you receive the code sent to this number',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.black45,
                    ),
                  )
                ],
              ),
              SizedBox(height: 40),
              Form(
                autovalidate: _autovalidate,
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 320,
                      decoration: boxDecoration,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onTap: () {
                          setState(() {
                            _autovalidate = false;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '*Required';
                          } else if (value.length < 10) {
                            return 'Number must be 10 digits long';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        controller: _phoneController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: 'your phone number',
                          hintStyle: fieldtext,
                        ),
                      ),
                    ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OTP(
                                      phoneNumber:
                                          '+977' + _phoneController.text,
                                    )));
                        // _enterPhone('+977' + _phoneController.text);
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
