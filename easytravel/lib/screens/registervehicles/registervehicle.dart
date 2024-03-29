import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/services/api.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VehicleRegistrationPage extends StatefulWidget {
  @override
  _VehicleRegistrationPageState createState() =>
      _VehicleRegistrationPageState();
}

class _VehicleRegistrationPageState extends State<VehicleRegistrationPage> {
// creating file type variable
  File _image, _vehicleImg;

// creating instance of dio package

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
                    MaterialPageRoute(builder: (context) => NavBarPage()));
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTextFields(context, 'Brand', 'Brand of the vehicle',
                          _onTap, brandNode, modelNode, _brandController, 370),
                      SizedBox(height: 30),
                      buildTextFields(
                          context,
                          'Model',
                          'Model of the vehicle',
                          _onTap,
                          modelNode,
                          licenseNumberNode,
                          _modelController,
                          370),
                      SizedBox(height: 30),
                      buildTextFields(
                          context,
                          'License Plate Number',
                          'License plate number of the vehicle',
                          _onTap,
                          licenseNumberNode,
                          categoryNode,
                          _licenseController,
                          370),
                      SizedBox(height: 30),
                      integerField(context, 'Price', 'Rate/Day', _onTap,
                          priceNode, serviceNode, _priceController, 370),
                      SizedBox(height: 30),
                      _buildServiceDropDown(),
                      SizedBox(height: 30),
                      _buildCategoryDropDown(),
                      SizedBox(height: 30),
                      _buildTextBox(_descriptionController),
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
                            uploadVehicleData(
                                _brandController.text,
                                _modelController.text,
                                _licenseController.text,
                                _categoryValue,
                                _serviceValue,
                                _descriptionController.text,
                                int.parse(_priceController.text),
                                _vehicleImg,
                                _image,
                                context);
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

// widget methid to build service drop down
  Widget _buildServiceDropDown() {
    return Container(
      width: 370,
      child: DropdownButtonFormField(
          focusNode: serviceNode,
          decoration: fieldsInputDecoration(null, 'Service'),
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
          }),
    );
  }

// widget method to build cateogry drop down
  Widget _buildCategoryDropDown() {
    return Container(
      width: 370,
      child: DropdownButtonFormField(
          focusNode: categoryNode,
          decoration: fieldsInputDecoration(null, 'Category'),
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
          }),
    );
  }

// Widget method to build multiline text field
  Widget _buildTextBox(TextEditingController _controller) {
    return Container(
      width: 370,
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
        decoration:
            fieldsInputDecoration('Details about vehicle', 'Description'),
      ),
    );
  }
}
