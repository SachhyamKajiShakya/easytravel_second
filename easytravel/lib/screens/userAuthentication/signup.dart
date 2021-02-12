import 'package:easy_travel/screens/userAuthentication/login.dart';
import 'package:easy_travel/screens/registervehicles/registerVehicle.dart';
import 'package:easy_travel/services/tokenStorage.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  FocusNode emailNode;
  FocusNode usernameNode;
  FocusNode pwNode;
  FocusNode confirmpwNode;
  FocusNode nameNode;
  FocusNode phoneNode;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpwController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String webToken;

  // future method to create user
  createUser(String email, String username, String password, String password2,
      String name, String phone) async {
    final http.Response response = await http.post(
      'http://192.168.100.67:8000/api/register/', //making http post call to api set through this url
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        //setting values to be added in the body
        <String, String>{
          'email': email,
          'username': username,
          'password': password,
          'password2': password2,
          'name': name,
          'phone': phone,
        },
      ),
    );
    //if new user is created then navigate user to home page else throw exception
    if (response.statusCode == 200) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => VehicleRegistrationPage()));
      String token = jsonDecode(response.body)['token'].toString();
      writeContent(token);
    } else {
      throw Exception('Failed to laod');
    }
  }

// widget method to build password field
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
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          hintText: 'Password',
          hintStyle: TextStyle(
              fontFamily: 'Cambria',
              fontSize: 15,
              color: Color.fromRGBO(125, 125, 125, 1)),
        ),
      ),
    );
  }

// widget method to build password field
  Widget buildConfirmPasswordfield() {
    return Container(
      height: 45,
      width: 350,
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        focusNode: confirmpwNode,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        obscureText: true,
        controller: _confirmpwController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          hintText: 'Confirm Password',
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
    emailNode = FocusNode();
    usernameNode = FocusNode();
    pwNode = FocusNode();
    confirmpwNode = FocusNode();
    nameNode = FocusNode();
    phoneNode = FocusNode();
  }

  @override
  void dispose() {
    emailNode.dispose();
    usernameNode.dispose();
    pwNode.dispose();
    confirmpwNode.dispose();
    nameNode.dispose();
    phoneNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  buildSubHeader('Sign Up'),
                ]),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField(nameNode, phoneNode, 'Full Name',
                        _nameController, context)
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField(phoneNode, emailNode, 'Phone number',
                        _phoneController, context)
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField(emailNode, usernameNode, 'Email',
                        _emailController, context)
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField(usernameNode, pwNode, 'Username',
                        _usernameController, context)
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildPasswordfield(),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildConfirmPasswordfield(),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: buildButton('Sign Up'),
                      onPressed: () {
                        createUser(
                            _emailController.text,
                            _usernameController.text,
                            _passwordController.text,
                            _confirmpwController.text,
                            _nameController.text,
                            _phoneController.text);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => OTPSection(
                        //               phoneNumber: _phoneController.text,
                        //             )));
                      },
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Aready have an account?",
                      style: TextStyle(
                          fontFamily: 'Cambria',
                          fontSize: 18,
                          color: Color.fromRGBO(125, 125, 125, 1)),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'Cambria',
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
