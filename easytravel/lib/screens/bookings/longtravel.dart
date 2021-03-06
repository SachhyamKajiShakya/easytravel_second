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

  String token;
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
      token = await readContent();
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
    Size size = MediaQuery.of(context).size;
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
            child: Form(
              key: _formkey,
              autovalidate: _autovalidate,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pickup Details',
                          style: TextStyle(fontSize: 18, letterSpacing: 1))
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      formRow('Province',
                          _provinceDropdown(_pickupProvince, size, 0.2)),
                      SizedBox(width: size.width * 0.20),
                      formRow(
                          'Number of days',
                          buildTimeField(_onTap, context, days, district, _days,
                              '2', size)),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      formRow(
                          'District',
                          buildBookingTextFields(context, _onTap, district,
                              city, _district, 'Kathmandu', size, 0.43)),
                      SizedBox(width: size.width * 0.03),
                      formRow(
                          'City',
                          buildBookingTextFields(context, _onTap, city, street,
                              _city, 'Koteshwor', size, 0.43)),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      formRow(
                          'Street',
                          buildBookingTextFields(context, _onTap, street, null,
                              _street, 'street', size, 0.9)),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      formRow('Pickup Date', _buildDateTextField(now, size)),
                      SizedBox(width: size.width * 0.03),
                      _pickupTimeRow(size)
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Destination',
                          style: TextStyle(fontSize: 18, letterSpacing: 1))
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      formRow(
                          'District',
                          buildBookingTextFields(
                              context,
                              _onTap,
                              destinationDistrict,
                              destinationCity,
                              _destinationDistrict,
                              'Kathmandu',
                              size,
                              0.43)),
                      SizedBox(width: size.width * 0.03),
                      formRow(
                          'City',
                          buildBookingTextFields(
                              context,
                              _onTap,
                              destinationCity,
                              destinationStreet,
                              _destinationCity,
                              'Koteshwor',
                              size,
                              0.43)),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      formRow(
                          'Street',
                          buildBookingTextFields(
                              context,
                              _onTap,
                              destinationStreet,
                              destinationProvince,
                              _destinationStreet,
                              'street',
                              size,
                              0.66)),
                      SizedBox(width: size.width * 0.03),
                      formRow('Province',
                          _provinceDropdown(_destinationProvince, size, 0.2)),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
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
                          }
                        },
                        child: buildButton('Request Booking', 300),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // pick up time set
  Widget _pickupTimeRow(Size size) {
    return Column(children: [
      Row(
        children: [
          Text('Pickup Time', style: TextStyle(fontSize: 15)),
        ],
      ),
      SizedBox(height: 15),
      Row(
        children: [
          buildTimeField(_onTap, context, hour, minute, _hour, '10', size),
          SizedBox(width: 8),
          buildTimeField(_onTap, context, minute, ampm, _minute, '00', size),
          SizedBox(width: 8),
          _buildTimeDropDown(size),
        ],
      ),
    ]);
  }

  // build date text field
  Widget _buildDateTextField(String hintText, Size size) {
    return Container(
      height: 45,
      width: size.width * 0.38,
      decoration: boxDecoration,
      child: TextFormField(
        focusNode: date,
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            hintText: hintText,
            hintStyle: fieldtext),
      ),
    );
  }

  // widget method to build cateogry drop down
  Widget _buildTimeDropDown(size) {
    return Container(
      width: size.width * 0.15,
      padding: EdgeInsets.only(left: 12, right: 2),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField(
          focusNode: ampm,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          value: _ampmValue,
          style: fieldtext,
          items: <String>['am', 'pm']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _ampmValue = value;
            });
          }),
    );
  }

  Widget _provinceDropdown(String provinceValue, Size size, double width) {
    return Container(
      width: size.width * width,
      padding: EdgeInsets.only(left: 35, right: 2),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 244, 244, 100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField(
          focusNode: province,
          decoration: InputDecoration(
            border: InputBorder.none,
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
