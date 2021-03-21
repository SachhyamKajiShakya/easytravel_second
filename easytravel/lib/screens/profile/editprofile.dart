import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/profile/userprofile.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Dio dio = new Dio(); //creating instance of Dio package
  bool showPassword = false; //boolean variable for obscuring text
  bool showConfirmpw = false; //boolean variable for obscuring text

  File _profilePicture; //File type variable

// method to get blue book image from gallery
  _imageFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        _profilePicture = File(image.path);
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      _imageFromGallery();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ));
        });
  }

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
                  child: _profilePicture != null
                      ? Stack(
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
                              ),
                              child: Image.file(_profilePicture),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: iconBoxDecoration,
                                child: Icon(Icons.edit, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: ppDecoration,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: iconBoxDecoration,
                                child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.edit, color: Colors.white),
                                    onPressed: () {
                                      _showPicker(context);
                                    }),
                              ),
                            ),
                          ],
                        ),
                ),
                Form(
                  autovalidate: _autovalidate,
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      _textFields('Name', 'Rohit Sharma', namenode,
                          usernamenode, _nameController),
                      SizedBox(height: 30),
                      _textFields('Username', 'Rohit', usernamenode,
                          contactnode, _usernameController),
                      SizedBox(height: 30),
                      _contactField('Contact', '9867356722', contactnode,
                          passwordnode, _contactController),
                      SizedBox(height: 30),
                      passwordField('Password', '********', true, passwordnode,
                          confirmpwnode, _pwController),
                      SizedBox(height: 30),
                      confirmpwField('Confirm Password', '********', true,
                          confirmpwnode, null, _confirmpwController),
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
  TextFormField passwordField(String label, String hint, bool isPassword,
      FocusNode node, FocusNode nextNode, TextEditingController controller) {
    return TextFormField(
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
        contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
        labelText: label,
        labelStyle: labelstyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: hintstyle,
      ),
    );
  }

  // method to build the text fields
  TextFormField confirmpwField(String label, String hint, bool isPassword,
      FocusNode node, FocusNode nextNode, TextEditingController controller) {
    return TextFormField(
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
    );
  }

// text field
  Widget _textFields(String label, String hint, FocusNode node,
      FocusNode nextNode, TextEditingController controller) {
    return TextFormField(
      onTap: () {
        setState(() {
          _autovalidate = false;
        });
      },
      controller: controller,
      focusNode: node,
      validator: (value) {
        if (value.isEmpty) {
          return '*required';
        } else if (value.contains(RegExp(r'[0-9]'))) {
          return 'invalid input';
        }
        return null;
      },
      onFieldSubmitted: (term) {
        node.unfocus();
        FocusScope.of(context).requestFocus(nextNode);
      },
      cursorColor: Color.fromRGBO(255, 230, 232, 1),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
        labelText: label,
        labelStyle: labelstyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: hintstyle,
      ),
    );
  }

  // text field for contact number
  Widget _contactField(String label, String hint, FocusNode node,
      FocusNode nextNode, TextEditingController controller) {
    return TextFormField(
      onTap: () {
        setState(() {
          _autovalidate = false;
        });
      },
      controller: controller,
      focusNode: node,
      validator: (value) {
        if (value.isEmpty) {
          return '*required';
        } else if (value.contains(RegExp(r'[a-zA-z-_!@#]'))) {
          return 'invalid input';
        } else if (value.length < 10) {
          return 'must be of 10 digits';
        }
        return null;
      },
      onFieldSubmitted: (term) {
        node.unfocus();
        FocusScope.of(context).requestFocus(nextNode);
      },
      cursorColor: Color.fromRGBO(255, 230, 232, 1),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
        labelText: label,
        labelStyle: labelstyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: hintstyle,
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
