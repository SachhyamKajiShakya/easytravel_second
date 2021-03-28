import 'package:easy_travel/constants.dart';
import 'package:easy_travel/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_travel/screens/bookings/payment.dart';

class BookShortTravel extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final AsyncSnapshot datasnapshot;
  final index;
  final dataindex;

  const BookShortTravel(
      {Key key, this.snapshot, this.datasnapshot, this.index, this.dataindex})
      : super(key: key);
  @override
  _BookShortTravelState createState() => _BookShortTravelState();
}

class _BookShortTravelState extends State<BookShortTravel> {
  void firebaseTrigger(BuildContext context) {}

  // focus nodes of pick up text fields
  FocusNode hour, minute, ampm, district, city, street;
  // focus node of destination text fields
  FocusNode destinationDistrict, destinationCity, destinationStreet;

  // text editing controller variables
  TextEditingController _hour = TextEditingController();
  TextEditingController _minute = TextEditingController();
  TextEditingController _district = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _street = TextEditingController();
  TextEditingController _destinationDistrict = TextEditingController();
  TextEditingController _destinationCity = TextEditingController();
  TextEditingController _destinationStreet = TextEditingController();

  // setting value of selected drop down menu
  String _ampmValue = 'am';
  // date picker attributes
  DateTime selectedDate = DateTime.now();
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

  final _formkey = GlobalKey<FormState>(); //form key
  String token;

  // function to set auto valdiate to false
  bool _autovalidate = false;
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        now = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    hour = FocusNode();
    minute = FocusNode();
    ampm = FocusNode();
    district = FocusNode();
    city = FocusNode();
    street = FocusNode();
    destinationDistrict = FocusNode();
    destinationCity = FocusNode();
    destinationStreet = FocusNode();
  }

  @override
  void dispose() {
    hour.dispose();
    minute.dispose();
    ampm.dispose();
    district.dispose();
    city.dispose();
    street.dispose();
    destinationDistrict.dispose();
    destinationCity.dispose();
    destinationStreet.dispose();
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
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formkey,
                    autovalidate: _autovalidate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // a row that contains fields for district and city
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTextFields(context, 'District', 'Kathmandu',
                                _onTap, district, city, _district, 170),
                            SizedBox(width: 30),
                            buildTextFields(context, 'City', 'Koteshwor',
                                _onTap, city, street, _city, 170),
                          ],
                        ),

                        SizedBox(height: 30),

                        // method called to set field for pick up street
                        buildTextFields(context, 'Street', 'Seti OP Margh',
                            _onTap, street, hour, _street, 370),

                        SizedBox(height: 30),

                        // method called to set field for pick up date
                        _buildDateField(context, 'Book From', now, 370),
                        SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // row containing fields for setting time of booking
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
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),

                        SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // row containing fields for district and city
                          children: [
                            buildTextFields(
                                context,
                                'District',
                                'Kathmandu',
                                _onTap,
                                destinationDistrict,
                                destinationCity,
                                _destinationDistrict,
                                170),
                            SizedBox(width: 30),
                            buildTextFields(
                                context,
                                'City',
                                'Kalanki',
                                _onTap,
                                destinationCity,
                                destinationStreet,
                                _destinationCity,
                                170),
                          ],
                        ),

                        SizedBox(height: 30),

                        // method called to build field for destination street
                        buildTextFields(
                            context,
                            'Street',
                            'Om Petrol Pump Road',
                            _onTap,
                            destinationStreet,
                            null,
                            _destinationStreet,
                            370),

                        SizedBox(height: 40),

                        Center(
                          child: FlatButton(
                            // a button when pressed send request for booking
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                makeShortbookings(
                                    now,
                                    _hour.text + _minute.text + _ampmValue,
                                    _district.text,
                                    _city.text,
                                    _street.text,
                                    _destinationDistrict.text,
                                    _destinationCity.text,
                                    _destinationStreet.text,
                                    widget.snapshot.data[widget.index]["id"]
                                        .toString(),
                                    widget.datasnapshot
                                        .data[widget.dataindex]["id"]
                                        .toString(),
                                    context);
                              }
                            },
                            child: buildButton('Request Booking', 250),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

// widget functiono to build date field with calendar selection
  Widget _buildDateField(
      BuildContext context, String label, String hint, double size) {
    return Container(
      width: size,
      child: TextFormField(
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        cursorColor: Color.fromRGBO(255, 230, 232, 1),
        decoration: fieldsInputDecoration(now, 'Pickup Date'),
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
          decoration: fieldsInputDecoration(null, 'Merediem'),
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
}
