import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/navbar.dart';
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
  final _formKey = GlobalKey<FormState>(); //global key for form

  FocusNode nameNode, addressNode, contactNode; //defining field nodes

  File _licenseImage; //file type variable to get the selected license image
  Dio _dio = new Dio(); //creating an instance of Dio package
  bool _autovalidate = false; //a boolean value to set valdation of form

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

// set auto validation
  _onTap() {
    setState(() {
      _autovalidate = false;
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

// text editing controller for text fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

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
        body: Container(
          padding: EdgeInsets.only(left: 20, top: 50, right: 20),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(child: buildSubHeader('Assign Driver')),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTextFields(context, 'Name', 'Rohit Sharma', _onTap,
                          nameNode, addressNode, _nameController, 370),
                      SizedBox(height: 30),
                      buildTextFields(context, 'Address', 'Baneshwor', _onTap,
                          addressNode, contactNode, _addressController, 370),
                      SizedBox(height: 30),
                      contactField(context, 'Contact', '9876123091', _onTap,
                          contactNode, null, _contactController, 370)
                    ],
                  ),
                ),
                SizedBox(height: 40),
                FlatButton(
                  child: buildImageContainer(_licenseImage, 'License Image'),
                  onPressed: () {
                    _showLicensePicker(context);
                  },
                ),
                SizedBox(height: 50),
                FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _uploadDriverData(
                        _nameController.text,
                        _contactController.text,
                        _addressController.text,
                        _licenseImage,
                      );
                    } else {
                      setState(() {
                        _autovalidate = true;
                      });
                    }
                  },
                  child: buildButton('Assign Driver', 300),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //api to upload data
  _uploadDriverData(
    String driverName,
    String driverContact,
    String driverAddress,
    File licenseImage,
  ) async {
    try {
      String token = await readContent();
      String licenseFileName = licenseImage.path.split('/').last;
      FormData formData = new FormData.fromMap({
        'driverName': driverName,
        'driverAddress': driverAddress,
        'driverContact': driverContact,
        'licenseImage': await MultipartFile.fromFile(licenseImage.path,
            filename: licenseFileName)
      });
      final response = await _dio.post(
          // 'https://fyp-easytravel.herokuapp.com/api/driver/',
          'http://192.168.100.67:8000/api/driver/',
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
}
