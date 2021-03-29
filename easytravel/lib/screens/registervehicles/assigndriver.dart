import 'package:easy_travel/constants.dart';
import 'package:easy_travel/services/api.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AssignDriver extends StatefulWidget {
  @override
  _AssignDriverState createState() => _AssignDriverState();
}

class _AssignDriverState extends State<AssignDriver> {
  final _formKey = GlobalKey<FormState>(); //global key for form

  FocusNode nameNode, addressNode, contactNode; //defining field nodes

  File _licenseImage; //file type variable to get the selected license image
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
                      buildTextFields(context, 'Name', 'Name of the driver',
                          _onTap, nameNode, addressNode, _nameController, 370),
                      SizedBox(height: 30),
                      buildTextFields(
                          context,
                          'Address',
                          'Address of the driver',
                          _onTap,
                          addressNode,
                          contactNode,
                          _addressController,
                          370),
                      SizedBox(height: 30),
                      contactField(
                          context,
                          'Contact',
                          'Contact number of the driver',
                          _onTap,
                          contactNode,
                          null,
                          _contactController,
                          370)
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
                      uploadDriverData(
                        _nameController.text,
                        _contactController.text,
                        _addressController.text,
                        _licenseImage,
                        context,
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
}
