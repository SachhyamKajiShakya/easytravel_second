import 'package:easy_travel/screens/password/resetpw.dart';
import 'package:easy_travel/screens/userauthentication/signup.dart';
import 'package:easy_travel/screens/registervehicles/registerVehicle.dart';
import 'package:easy_travel/services/fcmservices.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_travel/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String webToken;
  bool _autovalidate = false;
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;

  FocusNode usernameNode, pwNode;

// future method to login user
  Future<String> loginUser(String email, String password) async {
    final http.Response response = await http.post(
      // 'http://fyp-easytravel.herokuapp.com/api/login/',
      'http://192.168.100.67:8000/api/login/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'username': email,
          'password': password,
        },
      ),
    );
    if (response.statusCode == 200) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => VehicleRegistrationPage()));
      String token = jsonDecode(response.body)['token'].toString();
      //print(token);
      return token;
    } else {
      throw Exception('Failed to laod');
    }
  }

// function to get logged in user token
  void getToken() async {
    String userToken =
        await loginUser(_usernameController.text, _passwordController.text);
    writeContent(userToken);
    //print(userToken);
  }

  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

  @override
  void initState() {
    super.initState();
    usernameNode = FocusNode();
    pwNode = FocusNode();
  }

  @override
  void dispose() {
    usernameNode.dispose();
    pwNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(left: 20, top: 60, right: 20),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(child: buildSubHeader('Sign In')),
                SizedBox(height: 60),
                Form(
                  key: _formKey,
                  autovalidate: _autovalidate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTextFields(context, 'Username', 'username', _onTap,
                          usernameNode, pwNode, _usernameController, 370),
                      SizedBox(height: 30),
                      _passwordField('Password', '********', true, pwNode, null,
                          _passwordController, 370),
                      SizedBox(height: 40),
                      FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            getToken();
                          } else {
                            setState(() {
                              _autovalidate = true;
                            });
                          }
                        },
                        child: buildButton('Sign in', 250),
                      ),
                      SizedBox(height: 30),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordPage()));
                        },
                        child: Text(
                          'Forgot password?',
                          style: textSpan,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17,
                                color: Color.fromRGBO(100, 100, 100, 1)),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()));
                            },
                            child: Text(
                              'Create one',
                              style: textSpan,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // on tap function to set validation to false
  }

  // method to build the password text field
  Widget _passwordField(
      String label,
      String hint,
      bool isPassword,
      FocusNode node,
      FocusNode nextNode,
      TextEditingController controller,
      double width) {
    return Container(
      width: width,
      child: TextFormField(
        onTap: () {
          setState(() {
            _autovalidate = false;
          });
        },
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          } else if (value.length < 8) {
            return 'password must have 8 characters';
          } else if (value.contains(new RegExp(r'^[a-zA-Z0-9]+$')) == false) {
            return 'invalid input';
          }
          return null;
        },
        focusNode: node,
        controller: controller,
        cursorColor: cursorColor,
        obscureText: isPassword ? (showPassword ? true : false) : false,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(Icons.remove_red_eye, color: Colors.blueGrey),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3, left: 15, top: 3),
          labelText: label,
          labelStyle: labelstyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hint,
          hintStyle: hintstyle,
        ),
      ),
    );
  }
}
