import 'package:easy_travel/screens/userauthentication/signup.dart';
import 'package:easy_travel/screens/registervehicles/registerVehicle.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String webToken;
  bool _autovalidate = false;
  final _formKey = GlobalKey<FormState>();

  FocusNode usernameNode, pwNode;

// future method to login user
  Future<String> loginUser(String email, String password) async {
    final http.Response response = await http.post(
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
        await loginUser(_emailController.text, _passwordController.text);
    writeContent(userToken);
    //print(userToken);
  }

  Widget buildPasswordfield() {
    return Container(
      height: 45,
      width: 350,
      decoration: boxDecoration,
      child: TextFormField(
        onTap: _onTap,
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          } else if (value.length < 8) {
            return 'must have atleast 8 characters';
          } else {
            return null;
          }
        },
        focusNode: pwNode,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        obscureText: true,
        controller: _passwordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: 'password',
          hintStyle: fieldtext,
        ),
      ),
    );
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
      body: SingleChildScrollView(
        child: Form(
          autovalidate: _autovalidate,
          key: _formKey,
          child: Column(children: <Widget>[
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSubHeader('Sign In'),
              ],
            ),
            // calling widget method to set sub title
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUsernameTextField(usernameNode, pwNode, 'username',
                    _emailController, context),
              ],
            ),
            // calling widget method to set username text field
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPasswordfield(),
              ],
            ),
            // calling widget method to set password text field
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    // calling widget method to build sign in button
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        getToken();
                        //writeContent(webToken);
                      } else {
                        _onTap();
                      }
                    },
                    child: buildButton('Sign In', 300)),
              ],
            ),
            SizedBox(height: 20),
            // flatbutton to set forgot password and navigate to reset password section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => null));
                  },
                  child: Text(
                    'Forgot password?',
                    style: textSpan,
                  ),
                ),
              ],
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text(
                    'Create one',
                    style: textSpan,
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    ));
  }

  // widget method to build text fields
  Widget _buildUsernameTextField(FocusNode node, FocusNode nextNode,
      String hintText, TextEditingController _controller, context) {
    return Container(
      height: 45,
      width: 350,
      decoration: boxDecoration,
      child: TextFormField(
        onTap: _onTap,
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          } else if (value.length > 50) {
            return 'username limit extended';
          } else {
            return null;
          }
        },
        onFieldSubmitted: (term) {
          node.unfocus();
          FocusScope.of(context).requestFocus(nextNode);
        },
        focusNode: node,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: '$hintText',
          hintStyle: fieldtext,
        ),
      ),
    );
  }

  // on tap function to set validation to false
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }
}
