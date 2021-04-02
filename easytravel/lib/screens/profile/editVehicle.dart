import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/services/updateapi.dart';
import 'package:easy_travel/services/vehicleapi.dart';
import 'package:flutter/material.dart';
import '../profilewidgets.dart';

class EditVehicle extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final index;

  const EditVehicle({Key key, this.snapshot, this.index}) : super(key: key);
  @override
  _EditVehicleState createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  FocusNode _brandNode,
      _modelNode,
      _licenseNumberNode,
      _categoryNode,
      _serviceNode,
      _driverNameNode,
      _driverAddressNode,
      _driverContactNode,
      _descriptionNode,
      _priceNode;

  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _licenseController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _driverNameController = TextEditingController();
  TextEditingController _driverAddressController = TextEditingController();
  TextEditingController _driverContactController = TextEditingController();

  String _categoryValue;
  String _serviceValue;
  bool _autovalidate = false;

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _brandNode = FocusNode();
    _modelNode = FocusNode();
    _licenseNumberNode = FocusNode();
    _categoryNode = FocusNode();
    _serviceNode = FocusNode();
    _priceNode = FocusNode();
    _descriptionNode = FocusNode();
    _driverNameNode = FocusNode();
    _driverAddressNode = FocusNode();
    _driverContactNode = FocusNode();
  }

  void dispose() {
    super.dispose();
    _brandNode.dispose();
    _modelNode.dispose();
    _licenseNumberNode.dispose();
    _categoryNode.dispose();
    _serviceNode.dispose();
    _priceNode.dispose();
    _descriptionNode.dispose();
    _driverNameNode.dispose();
    _driverAddressNode.dispose();
    _driverContactNode.dispose();
  }

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
        body: FutureBuilder(
          future: getDriverDetails(widget.snapshot.data[widget.index]["id"]),
          builder: (context, datasnapshot) {
            print('vehicle price: ' +
                widget.snapshot.data[widget.index]["price"].toString());
            if (datasnapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, dataindex) {
                return Form(
                  key: _formKey,
                  autovalidate: _autovalidate,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Center(child: buildSubHeader('Edit Vehicle Credentials')),
                      SizedBox(height: 40),
                      _buildImageContainer(),
                      SizedBox(height: 50),
                      buildProfileTextFields(
                          context,
                          'Brand',
                          widget.snapshot.data[widget.index]["brand"],
                          _onTap,
                          _brandNode,
                          _modelNode,
                          _brandController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Model',
                          widget.snapshot.data[widget.index]["model"],
                          _onTap,
                          _modelNode,
                          _licenseNumberNode,
                          _modelController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'License Plate Number',
                          widget.snapshot.data[widget.index]["licenseNumber"],
                          _onTap,
                          _licenseNumberNode,
                          _categoryNode,
                          _licenseController,
                          370),
                      SizedBox(height: 30),
                      _buildServiceDropDown(),
                      SizedBox(height: 30),
                      _buildCategoryDropDown(),
                      SizedBox(height: 30),
                      _buildTextBox(),
                      SizedBox(height: 30),
                      buildProfileIntegerField(
                          context,
                          'Price',
                          widget.snapshot.data[widget.index]['price']
                              .toString(),
                          _onTap,
                          _priceNode,
                          null,
                          _priceController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Driver Name',
                          datasnapshot.data[dataindex]['driverName'],
                          _onTap,
                          _driverNameNode,
                          _driverAddressNode,
                          _driverNameController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Driver Address',
                          datasnapshot.data[dataindex]['driverAddress'],
                          _onTap,
                          _driverAddressNode,
                          _driverContactNode,
                          _driverAddressController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Driver Contact',
                          datasnapshot.data[dataindex]['driverContact'],
                          _onTap,
                          _driverContactNode,
                          null,
                          _driverContactController,
                          370),
                      SizedBox(height: 50),
                      FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print(_categoryValue != null &&
                                _categoryValue !=
                                    widget.snapshot.data[widget.index]
                                        ["category"]);
                            print(_categoryValue);
                            updateVehicleDetials(
                              _brandController.text.isEmpty
                                  ? widget.snapshot.data[widget.index]["brand"]
                                  : _brandController.text,
                              _modelController.text.isEmpty
                                  ? widget.snapshot.data[widget.index]["model"]
                                  : _modelController.text,
                              _licenseController.text.isEmpty
                                  ? widget.snapshot.data[widget.index]
                                      ["licenseNumber"]
                                  : _licenseController.text,
                              _categoryValue != null &&
                                      _categoryValue !=
                                          widget.snapshot.data[widget.index]
                                              ["category"]
                                  ? _categoryValue
                                  : widget.snapshot.data[widget.index]
                                      ["category"],
                              _serviceValue != null &&
                                      _categoryValue !=
                                          widget.snapshot.data[widget.index]
                                              ["service"]
                                  ? _serviceValue
                                  : widget.snapshot.data[widget.index]
                                      ["service"],
                              _descriptionController.text.isEmpty
                                  ? widget.snapshot.data[widget.index]
                                      ["description"]
                                  : _descriptionController.text,
                              widget.snapshot.data[widget.index]["price"],
                              widget.snapshot.data[widget.index]["id"],
                              context,
                              _driverNameController.text.isEmpty
                                  ? datasnapshot.data[dataindex]['driverName']
                                  : _driverNameController.text,
                              _driverAddressController.text.isEmpty
                                  ? datasnapshot.data[dataindex]
                                      ['driverAddress']
                                  : _driverAddressController.text,
                              _driverContactController.text.isEmpty
                                  ? datasnapshot.data[dataindex]
                                      ['driverContact']
                                  : _driverContactController.text,
                              widget.snapshot.data[widget.index]["id"],
                            );
                          } else {
                            setState(() {
                              _autovalidate = true;
                            });
                          }
                        },
                        child: buildButton('Save Changes', 250),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // widget methid to build service drop down
  Widget _buildServiceDropDown() {
    return Container(
      width: 370,
      child: DropdownButtonFormField(
          focusNode: _serviceNode,
          decoration: fieldsInputDecoration(
              widget.snapshot.data[widget.index]["service"], 'Service'),
          style: fieldtext,
          items: <String>['Driver Service', 'Self Driving and Driver Service']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(150, 150, 150, 1),
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
          focusNode: _categoryNode,
          decoration: fieldsInputDecoration(
              widget.snapshot.data[widget.index]['category'], 'Category'),
          style: fieldtext,
          items: <String>['Short Travel', 'Long Travel']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(150, 150, 150, 1),
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
  Widget _buildTextBox() {
    return Container(
      width: 370,
      child: TextFormField(
        onFieldSubmitted: (term) {
          _descriptionNode.unfocus();
          FocusScope.of(context).requestFocus(_priceNode);
        },
        focusNode: _descriptionNode,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: Colors.black,
        controller: _descriptionController,
        decoration: fieldsInputDecoration(
            widget.snapshot.data[widget.index]["description"], 'Description'),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Stack(
      children: [
        Container(
          height: 150,
          width: 170,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'http://192.168.100.67:8000${widget.snapshot.data[widget.index]['vehicleImage']}'),
                fit: BoxFit.fill),
          ),
        ),
        // Positioned(
        //   top: 0,
        //   right: 0,
        //   child: Container(
        //     height: 30,
        //     width: 30,
        //     decoration: BoxDecoration(
        //       color: Colors.blue,
        //     ),
        //     child: IconButton(
        //       onPressed: () {
        //         _showVehiclePicker(context);
        //       },
        //       padding: EdgeInsets.zero,
        //       icon: Icon(Icons.edit, color: Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
