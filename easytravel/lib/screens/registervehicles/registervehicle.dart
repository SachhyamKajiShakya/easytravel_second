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
  final _formkey = GlobalKey<FormState>();
  bool _autovalidate = false;
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

  File _image, _vehicleImg;
  String token;
  Dio _dio = Dio();

  FocusNode brandNode, modelNode, licenseNumberNode, categoryNode, serviceNode;
  FocusNode descriptionNode, priceNode;

//api to upload data
  uploadPhoto(
      String brand,
      String model,
      String licenseNumber,
      String category,
      String service,
      String description,
      int price,
      File vehicleImage,
      File bluebookImage,
      String token) async {
    try {
      token = await readContent();
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

  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _licenseController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  // setting default drop down value
  String _categoryValue = 'Short Travel';
  String _serviceValue = 'Driver Service';

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

// widget methid to build service drop down
  Widget _buildServiceDropDown() {
    return Container(
      width: 360,
      padding: EdgeInsets.only(left: 82, right: 15),
      decoration: boxDecoration,
      child: DropdownButtonFormField(
          focusNode: serviceNode,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          value: _serviceValue,
          style: fieldtext,
          items: <String>['Driver Service', 'Self Driving and Driver Service']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: Text(value),
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
      width: 350,
      padding: EdgeInsets.only(left: 140, right: 15),
      decoration: boxDecoration,
      child: DropdownButtonFormField(
          focusNode: categoryNode,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          value: _categoryValue,
          style: fieldtext,
          items: <String>['Short Travel', 'Long Travel']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _categoryValue = value;
            });
          }),
    );
  }

// Widget method to build multiline text field
  Widget _buildTextBox(TextEditingController _controller, String hintText) {
    return Container(
      height: 120,
      width: 350,
      decoration: boxDecoration,
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
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: Colors.black,
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          hintText: '$hintText',
          hintStyle: fieldtext,
        ),
      ),
    );
  }

// widget method to build brand text fields
  Widget _buildBrandTextField(FocusNode node, FocusNode nextNode,
      String hintText, TextEditingController _controller, context) {
    return Container(
      height: 45,
      width: 350,
      decoration: boxDecoration,
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          } else if (value.contains(new RegExp(r'[1-9]'))) {
            return 'invalid input';
          }
          return null;
        },
        onTap: _onTap,
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
          hintStyle: fieldtext,
        ),
      ),
    );
  }

  // widget method to build brand text fields
  Widget _buildPriceTextField(FocusNode node, FocusNode nextNode,
      String hintText, TextEditingController _controller, context) {
    return Container(
      height: 45,
      width: 350,
      decoration: boxDecoration,
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          }
          return null;
        },
        onTap: _onTap,
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
          hintStyle: fieldtext,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    brandNode = FocusNode();
    modelNode = FocusNode();
    licenseNumberNode = FocusNode();
    categoryNode = FocusNode();
    serviceNode = FocusNode();
    descriptionNode = FocusNode();
    priceNode = FocusNode();
  }

  @override
  void dispose() {
    brandNode.dispose();
    modelNode.dispose();
    licenseNumberNode.dispose();
    categoryNode.dispose();
    serviceNode.dispose();
    descriptionNode.dispose();
    priceNode.dispose();
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
              icon: headerIcon,
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NavBarPage()));
              },
              child: Text('Skip',
                  style: TextStyle(
                      fontFamily: 'Roboto', fontSize: 17, color: Colors.black)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Form(
            autovalidate: _autovalidate,
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [buildSubHeader('Register Vehicle')],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBrandTextField(brandNode, modelNode, 'Brand',
                        _brandController, context)
                  ],
                ),
                // calling widget method to set brand text field
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField(_onTap, modelNode, licenseNumberNode,
                        'Model', _modelController, context)
                  ],
                ),
                // calling widget method to set model text field
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField(_onTap, licenseNumberNode, descriptionNode,
                        'License Plate Number', _licenseController, context)
                  ],
                ),
                // calling widget method to set license number text field
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextBox(_descriptionController, 'Description')
                  ],
                ),

                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPriceTextField(priceNode, serviceNode, 'Price',
                        _priceController, context)
                  ],
                ),
                // calling widget method to set date of registration text field
                SizedBox(height: 25),

                // widget method to build service drop down
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildServiceDropDown()],
                ),

                SizedBox(height: 25),

                // widget method to build category drop down
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildCategoryDropDown()],
                ),

                SizedBox(height: 25),
                // row deefined to display the vehicle image selected
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: () {
                          _showVehiclePicker(context);
                        },
                        child:
                            buildImageContainer(_vehicleImg, 'Vehicle Image')),
                    FlatButton(
                        onPressed: () {
                          _showPicker(context);
                        },
                        child: buildImageContainer(_image, 'Bluebook Image')),
                  ],
                ),
                SizedBox(height: 50),
                // register vehicle button
                FlatButton(
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        uploadPhoto(
                            _brandController.text,
                            _modelController.text,
                            _licenseController.text,
                            _categoryValue,
                            _serviceValue,
                            _descriptionController.text,
                            int.parse(_priceController.text),
                            _vehicleImg,
                            _image,
                            token);
                      } else {
                        _onTap();
                      }
                    },
                    child: buildButton('Register Vehicle', 300)),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
