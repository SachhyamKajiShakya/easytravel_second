import 'package:easy_travel/screens/bookings/payment.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        now = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
    }
  }

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

// api for booking request
  _makeLongBookings(
      String province,
      String days,
      String date,
      String time,
      String district,
      String city,
      String street,
      String destinationProvince,
      String destinationDestrict,
      String destinationCity,
      String destinationStreet) async {
    try {
      String token = await readContent();
      final http.Response response = await http.post(
        'http://192.168.100.67:8000/api/longbooking/${widget.snapshot.data[widget.index]["id"]}/${widget.datasnapshot.data[widget.dataindex]["id"]}/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(
          <String, String>{
            'pick_up_province': province,
            'number_of_days': days,
            'pick_up_date': date,
            'pick_up_time': time,
            'pick_up_district': district,
            'pick_up_city': city,
            'pick_up_street': street,
            'destination_province': destinationProvince,
            'destination_district': destinationDestrict,
            'destination_city': destinationCity,
            'destination_street': destinationStreet,
          },
        ),
      );
      if (response.statusCode == 200) {
        print('success');
      } else {
        print('unsuccessful');
      }
    } catch (e) {
      print(e);
    }
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
                  Text('Pickup Details:',
                      style: TextStyle(
                          fontSize: 18, letterSpacing: 1, color: Colors.black)),
                  SizedBox(height: 30),
                  Form(
                    key: _formkey,
                    autovalidate: _autovalidate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            buildBookingTextFields(
                                context,
                                'District',
                                'Kathmandu',
                                _onTap,
                                district,
                                city,
                                _district,
                                170),
                            SizedBox(width: 30),
                            buildBookingTextFields(context, 'City', 'Koteshwor',
                                _onTap, city, street, _city, 170),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            buildBookingTextFields(
                                context,
                                'Street',
                                'Seti OP Margh',
                                _onTap,
                                street,
                                hour,
                                _street,
                                240),
                            SizedBox(width: 30),
                            _provinceDropdown(_pickupProvince, 'Province', 100),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            buildTimeField(context, 'Hour', '10', _onTap, hour,
                                minute, _hour, 110),
                            SizedBox(width: 20),
                            buildTimeField(context, 'Minute', '00', _onTap,
                                minute, ampm, _minute, 110),
                            SizedBox(width: 20),
                            _buildTimeDropDown('ampm', 110)
                          ],
                        ),
                        SizedBox(height: 40),
                        Text('Destination Details:',
                            style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 1,
                                color: Colors.black)),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            buildBookingTextFields(
                                context,
                                'District',
                                'Kathmandu',
                                _onTap,
                                destinationDistrict,
                                destinationCity,
                                _destinationDistrict,
                                170),
                            SizedBox(width: 30),
                            buildBookingTextFields(
                                context,
                                'City',
                                'Koteshwor',
                                _onTap,
                                destinationCity,
                                destinationStreet,
                                _destinationCity,
                                170),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            buildBookingTextFields(
                                context,
                                'Street',
                                'Seti OP Margh',
                                _onTap,
                                destinationStreet,
                                destinationProvince,
                                _destinationStreet,
                                240),
                            SizedBox(width: 30),
                            _provinceDropdown(
                                _destinationProvince, 'Province', 100),
                          ],
                        ),
                        SizedBox(height: 40),
                        Text('Booking For:',
                            style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 1,
                                color: Colors.black)),
                        SizedBox(height: 30),
                        buildBookingTextFields(context, 'Number of days', '5',
                            _onTap, days, null, _days, 170),
                        SizedBox(height: 40),
                        Center(
                          child: FlatButton(
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                _makeLongBookings(
                                  _pickupProvince,
                                  _days.text,
                                  now,
                                  _hour.text + _minute.text + _ampmValue,
                                  _district.text,
                                  _city.text,
                                  _street.text,
                                  _destinationProvince,
                                  _destinationDistrict.text,
                                  _destinationCity.text,
                                  _destinationStreet.text,
                                );
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => PaymentGateway()));
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

  // widget method to build cateogry drop down
  Widget _buildTimeDropDown(String label, double size) {
    return Container(
      width: size,
      // padding: EdgeInsets.only(left: 12, right: 2),
      child: DropdownButtonFormField(
          focusNode: ampm,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
            contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
            labelText: label,
            labelStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
                color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          value: _ampmValue,
          style: fieldtext,
          items: <String>['am', 'pm']
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
              _ampmValue = value;
            });
          }),
    );
  }

  Widget _provinceDropdown(String provinceValue, String label, double width) {
    return Container(
      width: width,
      child: DropdownButtonFormField(
          focusNode: province,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
            contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
            labelText: label,
            labelStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
                color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          value: provinceValue,
          style: fieldtext,
          items: <String>['1', '2', '3', '4', '5', '6', '7']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              provinceValue = value;
            });
          }),
    );
  }
}
