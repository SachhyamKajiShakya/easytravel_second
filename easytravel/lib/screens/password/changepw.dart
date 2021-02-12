import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:easy_travel/main.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldpwController = TextEditingController();
  final _newpwController = TextEditingController();
  final _confirmpwController = TextEditingController();

  // boolean variable for pw visibility
  bool _showOldpw = false;
  bool _showNewpw = false;
  bool _showConfirmpw = false;

  // widget method to build old password field
  Widget _buildOldPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        obscureText: _showOldpw ? false : true,
        controller: _oldpwController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(_showOldpw ? Icons.visibility : Icons.visibility_off,
                size: 20, color: Colors.black),
            onPressed: () {
              setState(() {
                _showOldpw = !_showOldpw;
              });
            },
          ),
          hintText: 'Old Password',
          hintStyle: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  // widget method to build old password field
  Widget _builNewPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        obscureText: _showNewpw ? false : true,
        controller: _newpwController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(_showNewpw ? Icons.visibility : Icons.visibility_off,
                size: 20, color: Colors.black),
            onPressed: () {
              setState(() {
                _showNewpw = !_showNewpw;
              });
            },
          ),
          hintText: 'New Password',
          hintStyle: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  // widget method to build old password field
  Widget _builConfirmPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        obscureText: _showConfirmpw ? false : true,
        controller: _confirmpwController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(_showConfirmpw ? Icons.visibility : Icons.visibility_off,
                size: 20, color: Colors.black),
            onPressed: () {
              setState(() {
                _showConfirmpw = !_showConfirmpw;
              });
            },
          ),
          hintText: 'Confirm Password',
          hintStyle: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_outlined, size: 30),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()));
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildSubHeader(
                    'Change Password'), // calling widget method to set sub title
                SizedBox(height: 50),

                _buildOldPasswordField(), // calling widget method to set old password text field
                SizedBox(height: 25),

                _builNewPasswordField(), // calling widget method to set new password text field
                SizedBox(height: 25),

                _builConfirmPasswordField(), // calling widget method to set confirm password text field
                SizedBox(height: 50),

                FlatButton(
                  onPressed: null,
                  child: buildButton('CHANGE PASSWORD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
