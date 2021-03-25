import 'package:easy_travel/screens/userAuthentication/login.dart';
import 'package:easy_travel/screens/registervehicles/registerVehicle.dart';
import 'package:easy_travel/services/fcmservices.dart';
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
  bool showPassword = false;
  bool showConfirmpw = false;

  FocusNode emailNode, usernameNode, pwNode, confirmpwNode, nameNode, phoneNode;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpwController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  String webToken;

  // future method to create user
  _createUser(String email, String username, String password, String password2,
      String name, String phone) async {
    final http.Response response = await http.post(
      // 'https://fyp-easytravel.herokuapp.com/api/register/', //making http post call to api set through this url
      'http://192.168.100.67:8000/api/register/',
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
      getDeviceToken();
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
      body: Container(
        padding: EdgeInsets.only(left: 20, top: 50, right: 20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: buildSubHeader('Sign Up'),
              ),
              SizedBox(height: 60),
              Form(
                key: _formkey,
                autovalidate: _autovalidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildTextFields(context, 'Name', 'full name', _onTap,
                        nameNode, emailNode, _nameController, 370),
                    SizedBox(height: 30),
                    buildTextFields(context, 'Email', 'your email address',
                        _onTap, emailNode, phoneNode, _emailController, 370),
                    SizedBox(height: 30),
                    buildTextFields(context, 'Username', 'your username',
                        _onTap, usernameNode, pwNode, _usernameController, 370),
                    SizedBox(height: 30),
                    _passwordField('Password', 'enter your password', true,
                        pwNode, confirmpwNode, _passwordController, 370),
                    SizedBox(height: 30),
                    _confirmpwField(
                        'Confirm Password',
                        're-enter your password',
                        true,
                        confirmpwNode,
                        null,
                        _confirmpwController,
                        370),
                    SizedBox(height: 40),
                    FlatButton(
                      onPressed: () {
                        if (_formkey.currentState.validate()) {
                          print(widget.phoneNumber);
                          _createUser(
                              _emailController.text,
                              _usernameController.text,
                              _passwordController.text,
                              _confirmpwController.text,
                              _nameController.text,
                              widget.phoneNumber);
                        } else {
                          _autovalidate = true;
                        }
                      },
                      child: buildButton('Sign Up', 250),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

// on tap function to set validation to false
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

// method to build the text fields
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

  // method to build the text fields
  Widget _confirmpwField(
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
            return 'must have atleast 8 characters';
          } else if (value != _passwordController.text) {
            return 'passwords do not match';
          } else {
            return null;
          }
        },
        focusNode: node,
        controller: controller,
        cursorColor: cursorColor,
        obscureText: isPassword ? (showConfirmpw ? true : false) : false,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(Icons.remove_red_eye, color: Colors.blueGrey),
                  onPressed: () {
                    setState(() {
                      showConfirmpw = !showConfirmpw;
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
