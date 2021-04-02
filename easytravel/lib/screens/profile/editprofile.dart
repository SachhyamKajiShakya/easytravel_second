import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/services/api.dart';
import 'package:easy_travel/services/updateapi.dart';
import 'package:flutter/material.dart';
import '../profilewidgets.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // creating focus nodes for fields
  FocusNode namenode, usernamenode, contactnode, emailNode;

// text editing controller for fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namenode = FocusNode();
    usernamenode = FocusNode();
    contactnode = FocusNode();
  }

  @override
  void dispose() {
    namenode.dispose();
    usernamenode.dispose();
    contactnode.dispose();
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
                Navigator.pop(context);
              }),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  padding: EdgeInsets.only(left: 20, top: 5, right: 20),
                  child: ListView(
                    children: [
                      Center(
                        child: buildSubHeader('Edit Profile'),
                      ),
                      SizedBox(height: 30),
                      buildAvatar(),
                      Form(
                        autovalidate: _autovalidate,
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60),
                            _buildTextFields(
                                context,
                                'Name',
                                snapshot.data['name'],
                                _onTap,
                                namenode,
                                usernamenode,
                                _nameController,
                                370),
                            SizedBox(height: 35),
                            _buildTextFields(
                                context,
                                'Username',
                                snapshot.data['username'],
                                _onTap,
                                usernamenode,
                                contactnode,
                                _usernameController,
                                370),
                            SizedBox(height: 35),
                            _buildEmailFields(
                                context,
                                'Email',
                                snapshot.data['email'],
                                _onTap,
                                emailNode,
                                contactnode,
                                _emailController,
                                370),
                            SizedBox(height: 35),
                            _contactField(
                                context,
                                'Contact',
                                snapshot.data['phone'],
                                _onTap,
                                contactnode,
                                null,
                                _contactController,
                                370),
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
                                updateUserData(
                                    _nameController.text.isEmpty
                                        ? snapshot.data['name']
                                        : _nameController.text,
                                    _emailController.text.isEmpty
                                        ? snapshot.data['email']
                                        : _emailController.text,
                                    _usernameController.text.isEmpty
                                        ? snapshot.data['username']
                                        : _usernameController.text,
                                    _contactController.text.isEmpty
                                        ? snapshot.data['phone']
                                        : _contactController.text,
                                    context);
                                _nameController.clear();
                                _emailController.clear();
                                _usernameController.clear();
                                _contactController.clear();
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
                );
              }),
        ),
      ),
    );
  }

  // build text field
  Widget _buildTextFields(
    BuildContext context,
    String label,
    String hint,
    Function function,
    FocusNode node,
    FocusNode nextNode,
    TextEditingController controller,
    double size,
  ) {
    return Container(
      width: size,
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty == false &&
              value.contains(new RegExp(r'[a-zA-z]')) == false) {
            return 'only contains alphabets';
          } else {
            return null;
          }
        },
        onTap: function,
        controller: controller,
        focusNode: node,
        onFieldSubmitted: (term) {
          node.unfocus();
          FocusScope.of(context).requestFocus(nextNode);
        },
        cursorColor: cursorColor,
        decoration: fieldsInputDecoration(hint, label),
      ),
    );
  }

// text field for contact number
  Widget _contactField(
      BuildContext context,
      String label,
      String hint,
      Function function,
      FocusNode node,
      FocusNode nextNode,
      TextEditingController controller,
      double size) {
    return Container(
      width: size,
      child: TextFormField(
          keyboardType: TextInputType.number,
          onTap: function,
          controller: controller,
          focusNode: node,
          validator: (value) {
            if (value.isEmpty == false &&
                value.contains(RegExp(r'[a-zA-z-_!@#]'))) {
              return 'invalid input';
            } else if (value.isEmpty == false && value.length < 10) {
              return 'must be of 10 digits';
            }
            return null;
          },
          onFieldSubmitted: (term) {
            node.unfocus();
            FocusScope.of(context).requestFocus(nextNode);
          },
          cursorColor: cursorColor,
          decoration: fieldsInputDecoration(hint, label)),
    );
  }

// build text field
  Widget _buildEmailFields(
    BuildContext context,
    String label,
    String hint,
    Function function,
    FocusNode node,
    FocusNode nextNode,
    TextEditingController controller,
    double size,
  ) {
    return Container(
      width: size,
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty == false &&
              value.contains(new RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")) ==
                  false) {
            return 'invalid input';
          } else {
            return null;
          }
        },
        onTap: function,
        controller: controller,
        focusNode: node,
        onFieldSubmitted: (term) {
          node.unfocus();
          FocusScope.of(context).requestFocus(nextNode);
        },
        cursorColor: cursorColor,
        decoration: fieldsInputDecoration(hint, label),
      ),
    );
  }
}
