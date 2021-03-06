import 'package:easy_travel/screens/userAuthentication/login.dart';
import 'package:easy_travel/screens/registervehicles/registerVehicle.dart';
import 'package:easy_travel/services/tokenStorage.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  final String phoneNumber;

  const SignupPage({Key key, this.phoneNumber}) : super(key: key);
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formkey = GlobalKey<FormState>();
  bool _autovalidate = false;

  FocusNode emailNode, usernameNode, pwNode, confirmpwNode, nameNode, phoneNode;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpwController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

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
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              autovalidate: _autovalidate,
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
                      _buildNameTextField(nameNode, phoneNode, 'full name',
                          _nameController, context)
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEmailTextField(emailNode, usernameNode, 'email',
                          _emailController, context)
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildUsernameTextField(usernameNode, pwNode, 'username',
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
                        child: buildButton('Sign Up', 300),
                        onPressed: () {
                          print(_emailController.text);
                          print(_usernameController.text);
                          print(_passwordController.text);
                          print(_confirmpwController.text);
                          print(_nameController.text);
                          if (_formkey.currentState.validate()) {
                            createUser(
                                _emailController.text,
                                _usernameController.text,
                                _passwordController.text,
                                _confirmpwController.text,
                                _nameController.text,
                                widget.phoneNumber);
                          } else {
                            setState(() {
                              _autovalidate = true;
                            });
                          }
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
                          style: textSpan,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

// widget method to build password field
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

// widget method to build password field
  Widget buildConfirmPasswordfield() {
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
          } else if (value != _passwordController.text) {
            return 'passwords do not match';
          } else {
            return null;
          }
        },
        focusNode: confirmpwNode,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        obscureText: true,
        controller: _confirmpwController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: 'rewrite password',
          hintStyle: fieldtext,
        ),
      ),
    );
  }

  // widget method to build name text fields
  Widget _buildNameTextField(FocusNode node, FocusNode nextNode,
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
          } else if (value.contains(new RegExp(r'[0-9]'))) {
            return 'invalid entry';
          }
          return null;
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

// widget method to build email text fields
  Widget _buildEmailTextField(FocusNode node, FocusNode nextNode,
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
          } else if (!value.contains('@')) {
            return 'invalid input';
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
