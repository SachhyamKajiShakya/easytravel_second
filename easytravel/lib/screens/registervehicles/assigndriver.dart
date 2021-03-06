import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/screens/registervehicles/registervehicle.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class AssignDriver extends StatefulWidget {
  @override
  _AssignDriverState createState() => _AssignDriverState();
}

class _AssignDriverState extends State<AssignDriver> {
  // defining variable for form
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

// defining focus nodes
  FocusNode nameNode, addressNode, contactNode;

// defining text editing controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  File _licenseImage;
  Dio _dio = new Dio();
  String token;

  // method to get vehicle image from gallery
  _licenseImgFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        _licenseImage = File(image.path);
      }
    });
  }

//function to pick image from gallery
  void _showLicensePicker(context) {
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
                      _licenseImgFromGallery();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ));
        });
  }

//api to upload data
  _uploadData(
    String driverName,
    String driverContact,
    String driverAddress,
    File licenseImage,
    String token,
  ) async {
    try {
      token = await readContent();
      String licenseFileName = licenseImage.path.split('/').last;
      FormData formData = new FormData.fromMap({
        'driverName': driverName,
        'driverAddress': driverAddress,
        'driverContact': driverContact,
        'licenseImage': await MultipartFile.fromFile(licenseImage.path,
            filename: licenseFileName)
      });
      final response = await _dio.post('http://192.168.100.67:8000/api/driver/',
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              headers: {'Authorization': 'Token $token'}));
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NavBarPage()));
      } else {
        print('error uploading file');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    nameNode = FocusNode();
    addressNode = FocusNode();
    contactNode = FocusNode();
  }

  @override
  void dispose() {
    nameNode.dispose();
    addressNode.dispose();
    contactNode.dispose();
    super.dispose();
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
              icon: headerIcon,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VehicleRegistrationPage()));
              }),
        ),
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Form(
            autovalidate: _autovalidate,
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [buildSubHeader('Assign Driver')],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNameTextField(_onTap, nameNode, addressNode,
                        'Driver Name', _nameController, context)
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField(_onTap, addressNode, contactNode,
                        'Driver Address', _addressController, context)
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 244, 244, 100),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onTap: _onTap,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '*required';
                          } else if (value.length < 10) {
                            return 'number must be 10 digit long';
                          }
                          return null;
                        },
                        focusNode: contactNode,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        controller: _contactController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: 'Driver Contact',
                          hintStyle: TextStyle(
                              fontFamily: 'Cambria',
                              fontSize: 15,
                              color: Color.fromRGBO(125, 125, 125, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child:
                          buildImageContainer(_licenseImage, 'License Image'),
                      onPressed: () {
                        _showLicensePicker(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _uploadData(
                              _nameController.text,
                              _contactController.text,
                              _addressController.text,
                              _licenseImage,
                              token);
                        } else {
                          _onTap();
                        }
                      },
                      child: buildButton('Assign Driver', 300),
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

  // widget method to build name text fields
  Widget _buildNameTextField(Function onTap, FocusNode node, FocusNode nextNode,
      String hintText, TextEditingController _controller, context) {
    return Container(
      height: 45,
      width: 350,
      decoration: boxDecoration,
      child: TextFormField(
        onTap: onTap,
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
        focusNode: node,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: '$hintText',
          hintStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: Color.fromRGBO(125, 125, 125, 1)),
        ),
      ),
    );
  }
}
