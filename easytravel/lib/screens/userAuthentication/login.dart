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
  @override
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String webToken;

  FocusNode usernameNode;
  FocusNode pwNode;

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
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.all(Radius.circular(29)),
      ),
      child: TextFormField(
        focusNode: pwNode,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        obscureText: true,
        controller: _passwordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: 'Password',
          hintStyle: TextStyle(
              fontFamily: 'Cambria',
              fontSize: 15,
              color: Color.fromRGBO(125, 125, 125, 1)),
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
              buildTextField(
                  usernameNode, pwNode, 'Username', _emailController, context),
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
                    getToken();
                    //writeContent(webToken);
                  },
                  child: buildButton('Sign In')),
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
                  style: TextStyle(
                      fontFamily: 'Cambria',
                      fontSize: 16,
                      color: Color.fromRGBO(125, 125, 125, 1)),
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
                    fontFamily: 'Cambria',
                    fontSize: 18,
                    color: Color.fromRGBO(125, 125, 125, 1)),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
                child: Text(
                  'Create one',
                  style: TextStyle(
                    fontFamily: 'Cambria',
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    ));
  }
}
