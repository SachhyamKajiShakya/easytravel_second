import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/screens/registervehicles/assigndriver.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class VehicleRegistrationPage extends StatefulWidget {
  @override
  _VehicleRegistrationPageState createState() =>
      _VehicleRegistrationPageState();
}

class _VehicleRegistrationPageState extends State<VehicleRegistrationPage> {
// creating file type variable
  File _image, _vehicleImg;

// creating instance of dio package
  Dio _dio = Dio();

  final _formKey = GlobalKey<FormState>();

  // defining field nodes
  FocusNode brandNode, modelNode, licenseNumberNode, categoryNode, serviceNode;
  FocusNode descriptionNode, priceNode;

  // defining field controller
  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _licenseController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  // defining value for drop downs
  String _categoryValue = 'Short Travel';
  String _serviceValue = 'Driver Service';

  // validation values
  bool _autovalidate = false;
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

  // method to get blue book image from gallery
  _imageFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  // method to get vehicle image from gallery
  _vehicleImgFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        _vehicleImg = File(image.path);
      }
    });
  }

  // show picker for blue book
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

// show picker for vehicle image
  void _showVehiclePicker(context) {
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
                      _vehicleImgFromGallery();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ));
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
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AssignDriver()));
              },
              child: Text('Skip',
                  style: TextStyle(
                      fontFamily: 'Roboto', fontSize: 17, color: Colors.black)),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20, top: 30, right: 20),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: buildSubHeader('Register vehicle'),
                ),
                SizedBox(height: 50),
                Form(
                  autovalidate: _autovalidate,
                  key: _formKey,
                  child: Column(
                    children: [
                      _textFields('Brand', 'Honda', brandNode, modelNode,
                          _brandController),
                      SizedBox(height: 30),
                      _textFields('Model', 'Civic', modelNode,
                          licenseNumberNode, _modelController),
                      SizedBox(height: 30),
                      _textFields('License Plate Number', 'NSS 567',
                          licenseNumberNode, categoryNode, _licenseController),
                      SizedBox(height: 30),
                      _textFields('Price', '1200', priceNode, serviceNode,
                          _priceController),
                      SizedBox(height: 30),
                      _buildServiceDropDown(),
                      SizedBox(height: 30),
                      _buildCategoryDropDown(),
                      SizedBox(height: 30),
                      _buildTextBox(_descriptionController, 'Description'),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                              onPressed: () {
                                _showVehiclePicker(context);
                              },
                              child: buildImageContainer(
                                  _vehicleImg, 'Vehicle Image')),
                          SizedBox(width: 20),
                          FlatButton(
                              onPressed: () {
                                _showPicker(context);
                              },
                              child: buildImageContainer(
                                  _image, 'Bluebook Image')),
                        ],
                      ),
                      SizedBox(height: 50),
                      FlatButton(
                        child: buildButton('Register Vehicle', 250),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _uploadVehicleData(
                                _brandController.text,
                                _modelController.text,
                                _licenseController.text,
                                _categoryValue,
                                _serviceValue,
                                _descriptionController.text,
                                int.parse(_priceController.text),
                                _vehicleImg,
                                _image);
                          } else {
                            setState(() {
                              _autovalidate = true;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// text fields
  Widget _textFields(String label, String hint, FocusNode node,
      FocusNode nextNode, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      focusNode: node,
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

// widget methid to build service drop down
  Widget _buildServiceDropDown() {
    return DropdownButtonFormField(
        focusNode: serviceNode,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
          labelText: 'Service',
          labelStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
              color: Colors.black),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        value: _serviceValue,
        style: fieldtext,
        items: <String>['Driver Service', 'Self Driving and Driver Service']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _serviceValue = value;
          });
        });
  }

// widget method to build cateogry drop down
  Widget _buildCategoryDropDown() {
    return DropdownButtonFormField(
        focusNode: categoryNode,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
          contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
          labelText: 'Service',
          labelStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
              color: Colors.black),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        value: _categoryValue,
        style: fieldtext,
        items: <String>['Short Travel', 'Long Travel']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _categoryValue = value;
          });
        });
  }

// Widget method to build multiline text field
  Widget _buildTextBox(TextEditingController _controller, String hintText) {
    return Container(
      height: 120,
      width: 370,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          }
          return null;
        },
        onFieldSubmitted: (term) {
          descriptionNode.unfocus();
          FocusScope.of(context).requestFocus(priceNode);
        },
        focusNode: descriptionNode,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: Colors.black,
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: '$hintText',
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  //api to upload data
  _uploadVehicleData(
    String brand,
    String model,
    String licenseNumber,
    String category,
    String service,
    String description,
    int price,
    File vehicleImage,
    File bluebookImage,
  ) async {
    try {
      String token = await readContent();
      String vehicleFileName = vehicleImage.path.split('/').last;
      String bluebookFileName = bluebookImage.path.split('/').last;

      FormData formData = FormData.fromMap({
        'brand': brand,
        'model': model,
        'licenseNumber': licenseNumber,
        'category': category,
        'service': service,
        'description': description,
        'price': price,
        'vehicleImage': await MultipartFile.fromFile(vehicleImage.path,
            filename: vehicleFileName),
        'bluebookImage': await MultipartFile.fromFile(bluebookImage.path,
            filename: bluebookFileName),
      });

      final response = await _dio.post(
          'http://192.168.100.67:8000/api/vehicle/',
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              headers: {'Authorization': 'Token $token'}));
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AssignDriver()));
      } else {
        print('error file uploading to server');
      }
    } catch (e) {
      print(e + 'error file uploading to server');
    }
  }
}
