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
  FocusNode nameNode;
  FocusNode addressNode;
  FocusNode contactNode;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
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
              icon: Icon(Icons.arrow_back_outlined,
                  size: 30, color: Colors.black),
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
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [buildSubHeader('Assign Driver')],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTextField(nameNode, addressNode, 'Driver Name',
                      _nameController, context)
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTextField(addressNode, contactNode, 'Driver Address',
                      _addressController, context)
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
                      borderRadius: BorderRadius.all(Radius.circular(29)),
                    ),
                    child: TextFormField(
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
                    child: buildImageContainer(_licenseImage, 'License Image'),
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
                      _uploadData(_nameController.text, _contactController.text,
                          _addressController.text, _licenseImage, token);
                    },
                    child: buildButton('Assign Driver'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
