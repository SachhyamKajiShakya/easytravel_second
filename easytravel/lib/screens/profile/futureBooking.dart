import 'package:easy_travel/screens/profilewidgets.dart';
import 'package:easy_travel/services/updateapi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class FutureBooking extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final index;

  const FutureBooking({Key key, this.snapshot, this.index}) : super(key: key);
  @override
  _FutureBookingState createState() => _FutureBookingState();
}

class _FutureBookingState extends State<FutureBooking> {
  DateTime selectedDate = DateTime.now();
  String now;

  // date picker in flutter
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        helpText: 'Select your booking date',
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        });
    if (picked != null &&
        picked != selectedDate &&
        picked.compareTo(selectedDate) >= 0) {
      // compare if selected date is greater than current date
      setState(() {
        selectedDate = picked;
        now = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
    } else {
      buildFailDialogBox(context, 'Invalid', 'Invalid date entry');
    }
  }

  FocusNode _districtNode,
      _cityNode,
      _streetNode,
      _destinationDistrictNode,
      _destinationCityNode,
      _dateNode,
      _timeNode,
      _destinationStreetNode;

  TextEditingController _districtController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _destinationDistrictController =
      TextEditingController();
  TextEditingController _destinationCityController = TextEditingController();
  TextEditingController _destinationStreetController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  bool _autovalidate = false;
  final _formkey = GlobalKey<FormState>();
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _districtNode = FocusNode();
    _cityNode = FocusNode();
    _streetNode = FocusNode();

    _destinationDistrictNode = FocusNode();
    _destinationCityNode = FocusNode();
    _destinationStreetNode = FocusNode();
    _dateNode = FocusNode();
    _timeNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _dateNode.dispose();
    _districtNode.dispose();
    _cityNode.dispose();
    _streetNode.dispose();

    _destinationDistrictNode.dispose();
    _destinationCityNode.dispose();
    _destinationStreetNode.dispose();
    _timeNode.dispose();
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
            print(widget.snapshot.data[widget.index]["id"]);
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              children: [
                Center(
                  child: buildSubHeader('Edit Booking Details'),
                ),
                SizedBox(height: 40),
                Form(
                  key: _formkey,
                  autovalidate: _autovalidate,
                  child: Column(
                    children: [
                      buildProfileTextFields(
                          context,
                          'Pickup Disctrict',
                          widget.snapshot.data[widget.index]
                              ["pick_up_district"],
                          _onTap,
                          _districtNode,
                          _cityNode,
                          _districtController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Pickup City',
                          widget.snapshot.data[widget.index]["pick_up_city"],
                          _onTap,
                          _cityNode,
                          _streetNode,
                          _cityController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Pickup Street',
                          widget.snapshot.data[widget.index]["pick_up_street"],
                          _onTap,
                          _streetNode,
                          _dateNode,
                          _streetController,
                          370),
                      SizedBox(height: 30),
                      _buildDateTextFields(
                          context,
                          'Pickup Date',
                          now == null
                              ? widget.snapshot.data[widget.index]
                                  ["pick_up_date"]
                              : now,
                          _dateNode,
                          _timeNode,
                          _dateController,
                          370),
                      SizedBox(height: 30),
                      _buildTimeTextFields(
                          context,
                          'Pickup Time',
                          widget.snapshot.data[widget.index]["pick_up_time"],
                          _timeNode,
                          _destinationDistrictNode,
                          _timeController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Desintation District',
                          widget.snapshot.data[widget.index]
                              ["destination_district"],
                          _onTap,
                          _destinationDistrictNode,
                          _destinationCityNode,
                          _destinationDistrictController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Desintation City',
                          widget.snapshot.data[widget.index]
                              ["destination_city"],
                          _onTap,
                          _destinationCityNode,
                          _destinationStreetNode,
                          _destinationCityController,
                          370),
                      SizedBox(height: 30),
                      buildProfileTextFields(
                          context,
                          'Desintation Street',
                          widget.snapshot.data[widget.index]
                              ["destination_street"],
                          _onTap,
                          _destinationStreetNode,
                          null,
                          _destinationStreetController,
                          370),
                      SizedBox(height: 40),
                      FlatButton(
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            print(now);
                            updateShortBooking(
                                widget.snapshot.data[widget.index]["id"],
                                _districtController.text.isEmpty
                                    ? widget.snapshot.data[widget.index]
                                        ["pick_up_district"]
                                    : _districtController.text,
                                _cityController.text.isEmpty
                                    ? widget.snapshot.data[widget.index]
                                        ["pick_up_city"]
                                    : _cityController.text,
                                _streetController.text.isEmpty
                                    ? widget.snapshot.data[widget.index]
                                        ["pick_up_street"]
                                    : _cityController.text,
                                now != null &&
                                        now !=
                                            widget.snapshot.data[widget.index]
                                                ["pick_up_date"]
                                    ? now
                                    : widget.snapshot.data[widget.index]
                                        ["pick_up_date"],
                                _timeController.text.isEmpty
                                    ? widget.snapshot.data[widget.index]
                                        ["pick_up_time"]
                                    : _timeController.text,
                                _destinationDistrictController.text.isEmpty
                                    ? widget.snapshot.data[widget.index]
                                        ["destination_district"]
                                    : _destinationDistrictController.text,
                                _destinationCityController.text.isEmpty
                                    ? widget.snapshot.data[widget.index]
                                        ["destination_city"]
                                    : _destinationCityController.text,
                                _destinationStreetController.text.isEmpty
                                    ? widget.snapshot.data[widget.index]
                                        ["destination_street"]
                                    : _destinationStreetController.text,
                                context);
                          }
                        },
                        child: buildButton('Save Changes', 250),
                      ),
                      SizedBox(height: 20),
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

  // build date text field for profile sections
  Widget _buildDateTextFields(
    BuildContext context,
    String label,
    String hint,
    FocusNode node,
    FocusNode nextNode,
    TextEditingController controller,
    double size,
  ) {
    return Container(
      width: size,
      child: TextFormField(
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
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

  // build time text field for profile sections
  Widget _buildTimeTextFields(
    BuildContext context,
    String label,
    String hint,
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
              value.contains(
                      new RegExp(r"^[0-9]{2}[:][0-9]{2}[' '][am|pm]+")) ==
                  false) {
            return 'invalid time format';
          } else {
            return null;
          }
        },
        onTap: () {
          setState(() {
            _autovalidate = false;
          });
        },
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
