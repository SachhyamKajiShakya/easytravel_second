import 'package:easy_travel/screens/bookings/payment.dart';
import 'package:easy_travel/services/api.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:intl/intl.dart';

import '../profilewidgets.dart';

class BookLongTravel extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final AsyncSnapshot datasnapshot;
  final index;
  final dataindex;

  const BookLongTravel(
      {Key key, this.snapshot, this.datasnapshot, this.index, this.dataindex})
      : super(key: key);
  @override
  _BookLongTravelState createState() => _BookLongTravelState();
}

class _BookLongTravelState extends State<BookLongTravel> {
  // focus node for pick up location
  FocusNode hour, minute, ampm, province, district, city, street, days, date;
// focus node for destination
  FocusNode destinationProvince,
      destinationDistrict,
      destinationCity,
      destinationStreet;

  // initializing TextEditingController
  TextEditingController _hour = TextEditingController();
  TextEditingController _minute = TextEditingController();
  TextEditingController _days = TextEditingController();
  TextEditingController _district = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _street = TextEditingController();
  TextEditingController _destinationDistrict = TextEditingController();
  TextEditingController _destinationCity = TextEditingController();
  TextEditingController _destinationStreet = TextEditingController();

  // setting local string value
  String _ampmValue = 'am';
  String _pickupProvince = '1';
  String _destinationProvince = '1';
  DateTime selectedDate = DateTime.now();
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateTime systemDate = DateTime.now();

  // list values for dropdowns
  var merediemList = ['am', 'pm'];
  var provinceList = ['1', '2', '3', '4', '5', '6', '7'];

  // setting variables and function for form validation
  final _formkey = GlobalKey<FormState>();
  bool _autovalidate = false;
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

  @override
  void initState() {
    super.initState();
    province = FocusNode();
    days = FocusNode();
    district = FocusNode();
    city = FocusNode();
    street = FocusNode();
    date = FocusNode();
    hour = FocusNode();
    minute = FocusNode();
    ampm = FocusNode();
    destinationDistrict = FocusNode();
    destinationCity = FocusNode();
    destinationStreet = FocusNode();
    destinationProvince = FocusNode();
  }

  @override
  void dispose() {
    province.dispose();
    days.dispose();
    district.dispose();
    city.dispose();
    street.dispose();
    date.dispose();
    hour.dispose();
    minute.dispose();
    ampm.dispose();
    destinationDistrict.dispose();
    destinationCity.dispose();
    destinationStreet.dispose();
    destinationProvince.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: headerIcon,
              onPressed: () {
                Navigator.pop(context);
              }),
          title: buildSubHeader('Make your bookings'),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Center(
                    child: Text('Pickup Details:',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formkey,
                    autovalidate: _autovalidate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTextFields(
                                context,
                                'District',
                                'Name of the district',
                                _onTap,
                                district,
                                city,
                                _district,
                                170),
                            SizedBox(width: 30),
                            buildTextFields(context, 'City', 'Name of the city',
                                _onTap, city, street, _city, 170),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTextFields(
                                context,
                                'Street',
                                'Name of the street',
                                _onTap,
                                street,
                                hour,
                                _street,
                                240),
                            SizedBox(width: 30),
                            _buildDropDown(province, 'Province', 100,
                                provinceList, _pickupProvince),
                          ],
                        ),
                        SizedBox(height: 30),
                        _buildDateField(context, 'Book From', now, 370),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTimeField(context, 'Hour', '10', _onTap, hour,
                                minute, _hour, 110),
                            SizedBox(width: 20),
                            buildTimeField(context, 'Minute', '00', _onTap,
                                minute, ampm, _minute, 110),
                            SizedBox(width: 20),
                            _buildDropDown(
                                ampm, 'Merediem', 110, merediemList, _ampmValue)
                          ],
                        ),
                        SizedBox(height: 40),
                        Text('Destination Details:',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTextFields(
                                context,
                                'District',
                                'Name of the district',
                                _onTap,
                                destinationDistrict,
                                destinationCity,
                                _destinationDistrict,
                                170),
                            SizedBox(width: 30),
                            buildTextFields(
                                context,
                                'City',
                                'Name of the city',
                                _onTap,
                                destinationCity,
                                destinationStreet,
                                _destinationCity,
                                170),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTextFields(
                                context,
                                'Street',
                                'Name of the street',
                                _onTap,
                                destinationStreet,
                                destinationProvince,
                                _destinationStreet,
                                240),
                            SizedBox(width: 30),
                            _buildDropDown(destinationProvince, 'Province', 100,
                                provinceList, _destinationProvince),
                          ],
                        ),
                        SizedBox(height: 40),
                        Text('Book For:',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        SizedBox(height: 30),
                        buildTimeField(context, 'Number of days', '5', _onTap,
                            days, null, _days, 170),
                        SizedBox(height: 40),
                        Center(
                          child: FlatButton(
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                makeLongBookings(
                                    _pickupProvince,
                                    _days.text,
                                    now,
                                    '${_hour.text}:${_minute.text} ' +
                                        _ampmValue,
                                    _district.text,
                                    _city.text,
                                    _street.text,
                                    _destinationProvince,
                                    _destinationDistrict.text,
                                    _destinationCity.text,
                                    _destinationStreet.text,
                                    widget.snapshot.data[widget.index]["id"]
                                        .toString(),
                                    widget.datasnapshot
                                        .data[widget.dataindex]["id"]
                                        .toString(),
                                    widget.snapshot.data[widget.index]
                                            ['price'] *
                                        int.parse(_days.text),
                                    context);
                              } else {
                                setState(() {
                                  _autovalidate = true;
                                });
                              }
                            },
                            child: buildButton('Request Booking', 300),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

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
        picked.compareTo(selectedDate) > 0) {
      setState(() {
        selectedDate = picked;
        now = DateFormat("yyyy-MM-dd").format(selectedDate);
        print(now);
      });
    } else {
      buildDialogBox(context, 'Invalid', 'Invalid date entry.', 'Okay');
    }
  }

  // widget method to build cateogry drop down
  Widget _buildDropDown(FocusNode node, String label, double size,
      var requiredList, String dataValue) {
    return Container(
      width: size,
      child: DropdownButtonFormField(
          focusNode: node,
          decoration: fieldsInputDecoration(null, label),
          value: dataValue,
          style: fieldtext,
          items: requiredList.map<DropdownMenuItem<String>>((String value) {
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
              dataValue = value;
            });
          }),
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, String hint, double size) {
    return Container(
      width: size,
      child: TextFormField(
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        cursorColor: cursorColor,
        decoration: fieldsInputDecoration(now, 'Pickup Date'),
      ),
    );
  }
}
