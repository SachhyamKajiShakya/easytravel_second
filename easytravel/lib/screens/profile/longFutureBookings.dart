import 'package:easy_travel/services/updateapi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../profilewidgets.dart';

class LongFutureBooking extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final index;

  const LongFutureBooking({Key key, this.snapshot, this.index})
      : super(key: key);

  @override
  _LongFutureBookingState createState() => _LongFutureBookingState();
}

class _LongFutureBookingState extends State<LongFutureBooking> {
  DateTime selectedDate = DateTime.now();
  String now;
  String _pickupProvince;
  String _destinationProvince;
  var provinceList = ['1', '2', '3', '4', '5', '6', '7'];

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
      // compare if selected date is greater than current date
      setState(() {
        selectedDate = picked;
        now = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
    }
  }

  bool _autovalidate = false;
  final _formkey = GlobalKey<FormState>();
  _onTap() {
    setState(() {
      _autovalidate = false;
    });
  }

  FocusNode _districtNode,
      _cityNode,
      _streetNode,
      _hourNode,
      _minuteNode,
      _destinationDistrictNode,
      _destinationCityNode,
      _destinationStreetNode,
      _dateNode,
      _timeNode,
      _daysNode;

  TextEditingController _districtController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _streetController = TextEditingController();

  TextEditingController _destinationDistrictController =
      TextEditingController();
  TextEditingController _destinationCityController = TextEditingController();
  TextEditingController _destinationStreetController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _districtNode = FocusNode();
    _cityNode = FocusNode();
    _streetNode = FocusNode();
    _hourNode = FocusNode();
    _minuteNode = FocusNode();
    _destinationDistrictNode = FocusNode();
    _destinationCityNode = FocusNode();
    _destinationStreetNode = FocusNode();
    _daysNode = FocusNode();
    _dateNode = FocusNode();
    _timeNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _districtNode.dispose();
    _cityNode.dispose();
    _streetNode.dispose();
    _hourNode.dispose();
    _minuteNode.dispose();
    _destinationDistrictNode.dispose();
    _destinationCityNode.dispose();
    _destinationStreetNode.dispose();
    _daysController.dispose();
    _dateNode.dispose();
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
              icon: headerIcon,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
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
                    _buildDropDown(
                        null,
                        widget.snapshot.data[widget.index]["pick_up_province"]
                            .toString(),
                        'Pickup Province',
                        370,
                        provinceList,
                        _pickupProvince),
                    SizedBox(height: 30),
                    buildProfileTextFields(
                        context,
                        'Pickup Disctrict',
                        widget.snapshot.data[widget.index]["pick_up_district"],
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
                            ? widget.snapshot.data[widget.index]["pick_up_date"]
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
                    _buildDestinationDropDown(
                        null,
                        widget
                            .snapshot.data[widget.index]["destination_province"]
                            .toString(),
                        'Destination Province',
                        370,
                        provinceList,
                        _destinationProvince),
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
                        widget.snapshot.data[widget.index]["destination_city"],
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
                        _daysNode,
                        _destinationStreetController,
                        370),
                    SizedBox(height: 30),
                    buildProfileTextFields(
                        context,
                        'Booked For',
                        widget.snapshot.data[widget.index]["number_of_days"]
                                .toString() +
                            ' days',
                        _onTap,
                        _daysNode,
                        null,
                        _daysController,
                        370),
                    SizedBox(height: 40),
                    FlatButton(
                      onPressed: () {
                        if (_formkey.currentState.validate()) {
                          print(_pickupProvince);
                          print(widget.snapshot.data[widget.index]
                              ["pick_up_province"]);
                          updateLongBooking(
                              widget.snapshot.data[widget.index]["id"],
                              _pickupProvince != null &&
                                      _pickupProvince !=
                                          widget.snapshot.data[widget.index]["pick_up_province"]
                                              .toString()
                                  ? _pickupProvince
                                  : widget.snapshot
                                      .data[widget.index]["pick_up_province"]
                                      .toString(),
                              widget.snapshot.data[widget.index]
                                  ["pick_up_district"],
                              widget.snapshot.data[widget.index]
                                  ["pick_up_city"],
                              widget.snapshot.data[widget.index]
                                  ["pick_up_street"],
                              widget.snapshot.data[widget.index]
                                  ["pick_up_date"],
                              widget.snapshot.data[widget.index]
                                  ["pick_up_time"],
                              _destinationProvince != null &&
                                      _destinationProvince !=
                                          widget
                                              .snapshot
                                              .data[widget.index]
                                                  ["destination_province"]
                                              .toString()
                                  ? _destinationProvince
                                  : widget.snapshot.data[widget.index]["destination_province"].toString(),
                              widget.snapshot.data[widget.index]["destination_district"],
                              widget.snapshot.data[widget.index]["destination_city"],
                              widget.snapshot.data[widget.index]["destination_street"],
                              widget.snapshot.data[widget.index]["number_of_days"],
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

  // widget method to build cateogry drop down
  Widget _buildDropDown(FocusNode node, String hint, String label, double size,
      var requiredList, String dataValue) {
    return Container(
      width: size,
      child: DropdownButtonFormField(
          focusNode: node,
          decoration: fieldsInputDecoration(hint, label),
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
              _pickupProvince = value;
            });
          }),
    );
  }

  // widget method to build cateogry drop down
  Widget _buildDestinationDropDown(FocusNode node, String hint, String label,
      double size, var requiredList, String dataValue) {
    return Container(
      width: size,
      child: DropdownButtonFormField(
          focusNode: node,
          decoration: fieldsInputDecoration(hint, label),
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
              _destinationProvince = value;
            });
          }),
    );
  }
}
