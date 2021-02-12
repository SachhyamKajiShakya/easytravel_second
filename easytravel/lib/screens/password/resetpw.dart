import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newpwController = TextEditingController();
  final _confirmpwController = TextEditingController();

// boolean variabe for password visibility
  bool showNewpw = false;
  bool showConfirmpw = false;

  // widget method to build new password field
  Widget _buildNewPasswordfield() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.all(Radius.circular(29)),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        obscureText: showNewpw ? false : true,
        controller: _newpwController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(
              showNewpw ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                showNewpw = !showNewpw;
              });
            },
          ),
          hintText: 'New Password',
          hintStyle: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  // widget method to build confirm password field
  Widget _buildConfirmPasswordfield() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.all(Radius.circular(29)),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        obscureText: showConfirmpw ? false : true,
        controller: _confirmpwController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(
              showConfirmpw ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                showConfirmpw = !showConfirmpw;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_outlined, size: 30),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => null));
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildSubHeader(
                    'Reset Password'), // calling widget method to set sub title
                SizedBox(height: 50),

                _buildNewPasswordfield(),
                SizedBox(height: 25),
                _buildConfirmPasswordfield(),
                SizedBox(height: 50),

                buildButton('RESET PASSWORD')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
