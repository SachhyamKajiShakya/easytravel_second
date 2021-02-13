import 'package:easy_travel/constants.dart';
import 'package:flutter/material.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  TextEditingController _phoneController = TextEditingController();
  String _phoneNumber;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("What's your phone number?",
                      style: TextStyle(fontFamily: 'Cambria', fontSize: 28))
                ],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(244, 244, 244, 100),
                      borderRadius: BorderRadius.all(Radius.circular(29)),
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      cursorColor: Colors.black,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Your phone number',
                        hintStyle: TextStyle(
                            fontFamily: 'Cambria',
                            fontSize: 15,
                            color: Color.fromRGBO(125, 125, 125, 1)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: null,
                    child: buildButton('Submit'),
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
