import 'package:easy_travel/constants.dart';
import 'package:easy_travel/main.dart';
import 'package:easy_travel/screens/userAuthentication/signup.dart';
import 'package:easy_travel/services/api.dart';
import 'package:flutter/material.dart';

class OTP extends StatefulWidget {
  final String phoneNumber;

  const OTP({Key key, this.phoneNumber}) : super(key: key);
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final _formkey = GlobalKey<FormState>();
  bool _autovalidate = false;

  TextEditingController _otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String phone = widget.phoneNumber;
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
            'OTP Verification',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Roboto', fontSize: 20),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: ListView(
            children: [
              Center(
                  child:
                      Container(child: buildSubHeader('Account Activation'))),
              SizedBox(height: 30),

              Center(
                child: Text(
                  'Enter the 6 digit code send to this number',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.black45,
                  ),
                ),
              ),

              SizedBox(height: 5),

              Center(
                child: Text(
                  '$phone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ),

              SizedBox(height: 40),
              Form(
                autovalidate: _autovalidate,
                key: _formkey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 320,
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
                            } else if (value.length < 6) {
                              return 'OTP must be 6 digit long';
                            }
                            return null;
                          },
                          cursorColor: cursorColor,
                          controller: _otp,
                          decoration: fieldsInputDecoration(
                              'Your 6-digit OTP code', 'OTP')),
                    ),
                  ],
                ),
              ),
              // Row(children: [Text(_errorText)],),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage(
                                    phoneNumber: widget.phoneNumber)));
                        // enterOtp(_otp.text, widget.phoneNumber, context);
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
