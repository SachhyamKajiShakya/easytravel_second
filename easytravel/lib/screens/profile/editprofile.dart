import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/profile/userprofile.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Dio dio = new Dio(); //creating instance of Dio package
  bool showPassword = false; //boolean variable for obscuring text
  bool showConfirmpw = false; //boolean variable for obscuring text

  // creating focus nodes for fields
  FocusNode namenode, usernamenode, contactnode, passwordnode, confirmpwnode;

// text editing controller for fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _confirmpwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namenode = FocusNode();
    usernamenode = FocusNode();
    contactnode = FocusNode();
    passwordnode = FocusNode();
    confirmpwnode = FocusNode();
  }

  @override
  void dispose() {
    namenode.dispose();
    usernamenode.dispose();
    contactnode.dispose();
    passwordnode.dispose();
    confirmpwnode.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined,
                  size: 22, color: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserProfile()));
              }),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20, top: 15, right: 20),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: buildSubHeader('Edit Profile'),
                ),
                SizedBox(height: 35),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.white,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('images/avatar.png')),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  autovalidate: _autovalidate,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      buildTextFields(context, 'Name', 'Rohit Sharma', _onTap,
                          namenode, usernamenode, _nameController, 370),
                      SizedBox(height: 30),
                      buildTextFields(context, 'Username', 'Rohit', _onTap,
                          usernamenode, contactnode, _usernameController, 370),
                      SizedBox(height: 30),
                      contactField(context, 'Contact', '9867356722', _onTap,
                          contactnode, passwordnode, _contactController, 370),
                      SizedBox(height: 30),
                      _passwordField('Password', '********', true, passwordnode,
                          confirmpwnode, _pwController, 370),
                      SizedBox(height: 30),
                      confirmpwField('Confirm Password', '********', true,
                          confirmpwnode, null, _confirmpwController, 370),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: buildButton('Save', 200),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print('success');
                        } else {
                          setState(() {
                            _autovalidate = true;
                          });
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        cursorColor: Color.fromRGBO(255, 230, 232, 1),
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
  Widget confirmpwField(
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
          } else if (value != _pwController.text) {
            return 'passwords do not match';
          } else {
            return null;
          }
        },
        focusNode: node,
        controller: controller,
        cursorColor: Color.fromRGBO(255, 230, 232, 1),
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
          contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
          labelText: label,
          labelStyle: labelstyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hint,
          hintStyle: hintstyle,
        ),
      ),
    );
  }

  // _uploadChanges(String name, String username, String contact, String password,
  //     String confirmPassword) async {
  //   try {
  //     String token = await readContent();
  //   } catch (e) {

  //   }
  // }
}
