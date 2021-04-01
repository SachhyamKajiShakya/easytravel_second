import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/services/api.dart';
import 'package:easy_travel/services/updateapi.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // defining text field controllers
  TextEditingController _oldpwController = TextEditingController();
  TextEditingController _newpwController = TextEditingController();
  TextEditingController _confirmpwController = TextEditingController();

  // defining focus nodes
  FocusNode _oldpwNode, _newpwNode, _confirmpwNode;

// defining variables for form
  bool _autovalidate = false;
  final _formkey = GlobalKey<FormState>();
  bool showPassword = false;
  bool showConfirmpw = false;
  @override
  void initState() {
    super.initState();
    _oldpwNode = FocusNode();
    _newpwNode = FocusNode();
    _confirmpwNode = FocusNode();
  }

  @override
  void dispose() {
    _oldpwNode.dispose();
    _newpwNode.dispose();
    _confirmpwNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined,
                  size: 22, color: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NavBarPage()));
              }),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: [
                      Center(
                        child: buildSubHeader('Change Password'),
                      ),
                      SizedBox(height: 50),
                      Form(
                        key: _formkey,
                        autovalidate: _autovalidate,
                        child: Column(
                          children: [
                            _oldPasswordField(),
                            SizedBox(height: 30),
                            _newPasswordField(),
                            SizedBox(height: 30),
                            _confirmPasswordField(),
                            SizedBox(height: 50),
                            FlatButton(
                              onPressed: () {
                                if (_formkey.currentState.validate()) {
                                  updatePassword(_oldpwController.text,
                                      _newpwController.text, context);
                                } else {
                                  setState(() {
                                    _autovalidate = true;
                                  });
                                }
                              },
                              child: buildButton('Change Password', 250),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }

  // method to build the text fields
  Widget _oldPasswordField() {
    return Container(
      width: 370,
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
          //  else if (value != oldpassword) {
          //   return 'does not match current password';
          // }
          return null;
        },
        focusNode: _oldpwNode,
        controller: _oldpwController,
        onFieldSubmitted: (term) {
          _oldpwNode.unfocus();
          FocusScope.of(context).requestFocus(_newpwNode);
        },
        cursorColor: cursorColor,
        obscureText: showPassword ? true : false,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye, color: Colors.blueGrey),
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
          contentPadding: EdgeInsets.only(bottom: 3, left: 15, top: 3),
          labelText: 'Old Password',
          labelStyle: labelstyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: 'Enter your current password',
          hintStyle: hintstyle,
        ),
      ),
    );
  }

  // method to build the text fields
  Widget _newPasswordField() {
    return Container(
      width: 370,
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
        focusNode: _newpwNode,
        controller: _newpwController,
        onFieldSubmitted: (term) {
          _newpwNode.unfocus();
          FocusScope.of(context).requestFocus(_confirmpwNode);
        },
        cursorColor: cursorColor,
        obscureText: showPassword ? true : false,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye, color: Colors.blueGrey),
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
          contentPadding: EdgeInsets.only(bottom: 3, left: 15, top: 3),
          labelText: 'New Password',
          labelStyle: labelstyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: 'Enter new password',
          hintStyle: hintstyle,
        ),
      ),
    );
  }

  // method to build the text fields
  Widget _confirmPasswordField() {
    return Container(
      width: 370,
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
          } else if (value != _newpwController.text) {
            return 'passwords do not match';
          } else {
            return null;
          }
        },
        focusNode: _confirmpwNode,
        controller: _confirmpwController,
        onFieldSubmitted: (term) {
          _confirmpwNode.unfocus();
          FocusScope.of(context).requestFocus(null);
        },
        cursorColor: cursorColor,
        obscureText: showConfirmpw ? true : false,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye, color: Colors.blueGrey),
            onPressed: () {
              setState(() {
                showConfirmpw = !showConfirmpw;
              });
            },
          ),
          contentPadding: EdgeInsets.only(bottom: 3, left: 15, top: 3),
          labelText: 'Confirm Password',
          labelStyle: labelstyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: 'Re-enter your new password',
          hintStyle: hintstyle,
        ),
      ),
    );
  }
}
