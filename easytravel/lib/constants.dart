import 'dart:ui';
import 'package:easy_travel/screens/bookings/confirmbooking.dart';
import 'package:easy_travel/screens/bookings/confirmlongbooking.dart';
import 'package:easy_travel/screens/password/resetpw.dart';
import 'package:easy_travel/screens/profile/editprofile.dart';
import 'package:easy_travel/screens/profile/userprofile.dart';
import 'package:easy_travel/services/getbooking.dart';
import 'package:flutter/material.dart';
import 'dart:io';

const cursorColor = Colors.black;
const fieldtext = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    color: Color.fromRGBO(125, 125, 125, 1));

const boxDecoration = BoxDecoration(
  color: Color.fromRGBO(230, 230, 230, 100),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

// box decoration for navbar icons
BoxDecoration iconBoxDecoration = BoxDecoration(
  shape: BoxShape.circle,
  border: Border.all(
    width: 2,
    color: Colors.white,
  ),
  color: Colors.redAccent,
);

// box decoration for profile picture decoration
BoxDecoration ppDecoration = BoxDecoration(
  border: Border.all(
    width: 2,
    color: Colors.white,
  ),
  boxShadow: [
    BoxShadow(
        spreadRadius: 2,
        blurRadius: 10,
        color: Colors.black.withOpacity(0.1),
        offset: Offset(0, 10))
  ],
  shape: BoxShape.circle,
  image: DecorationImage(
      fit: BoxFit.cover, image: AssetImage('images/avatar.png')),
);

// icon design properties for arrow icon on navbar
const headerIcon = Icon(
  Icons.arrow_back_outlined,
  size: 22,
  color: Colors.black,
);

// text style for span texts
const textSpan = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 17,
  color: Colors.lightBlue,
  decoration: TextDecoration.underline,
);

// text style for label text
TextStyle labelstyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.6,
    color: Colors.black);

// text style for hint text
TextStyle hintstyle = TextStyle(
  fontSize: 16,
  color: Color.fromRGBO(150, 150, 150, 1),
);

// input decoration for text fields
InputDecoration fieldsInputDecoration(String hintText, String labelText) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    contentPadding: EdgeInsets.only(bottom: 8, left: 15, top: 3),
    labelText: labelText,
    labelStyle: labelstyle,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    hintText: hintText,
    hintStyle: hintstyle,
  );
}

// Widget method to build header
Widget buildHeader(BuildContext context) {
  return Text(
    'Easy Travel',
    style: TextStyle(color: Colors.black, fontFamily: 'Roboto', fontSize: 50),
  );
}

// Widget method to build subheader
Widget buildSubHeader(String text) {
  return Text(
    '$text',
    style: TextStyle(fontFamily: 'Roboto', fontSize: 26, color: Colors.black),
  );
}

// Widget method to build rest of the buttons
Widget buildButton(String text, double width) {
  return Container(
    width: width,
    height: 45,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        '$text',
        style:
            TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 20),
      ),
    ),
  );
}

// widget method to build image button
Widget buildImageButton(String text) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    height: 45.0,
    decoration: BoxDecoration(
      color: Color.fromRGBO(229, 229, 229, 100),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Text(
      '$text',
      style: TextStyle(
        color: Colors.black,
        letterSpacing: 0.5,
        fontSize: 13,
      ),
    ),
  );
}

// widget method to build image container
Widget buildImageContainer(File img, String hintTxt) {
  return img != null
      ? Container(
          child: Image.file(img, width: 140, height: 120, fit: BoxFit.fill),
        )
      : Container(
          height: 110,
          width: 125,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromRGBO(210, 210, 210, 1), width: 1.2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Color.fromRGBO(125, 125, 125, 1),
                    size: 30,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hintTxt,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color.fromRGBO(125, 125, 125, 1),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
}

// widget function to build the card bodies
Widget buildBodyCard(
    AsyncSnapshot snapshot, index, BuildContext context, Function press) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 15, right: 5),
      child: GestureDetector(
        onTap: press,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                width: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.network(
                    'http://192.168.100.67:8000${snapshot.data[index]["vehicleImage"]}',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 12.0),
                child: Text(
                    snapshot.data[index]["brand"] +
                        ' ' +
                        snapshot.data[index]["model"],
                    style: Theme.of(context).textTheme.headline4),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 8.0),
                child: Text(
                    'Rs ' + snapshot.data[index]["price"].toString() + '/km',
                    style: Theme.of(context).textTheme.headline3),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// pick up time field
Widget buildTimeField(
  BuildContext context,
  String label,
  String hint,
  Function function,
  FocusNode node,
  FocusNode nextNode,
  TextEditingController controller,
  double size,
) {
  return Container(
      width: size,
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          } else if (value.length > 2) {
            return 'invalid input';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: controller,
        focusNode: node,
        onFieldSubmitted: (term) {
          node.unfocus();
          FocusScope.of(context).requestFocus(nextNode);
        },
        cursorColor: cursorColor,
        decoration: fieldsInputDecoration(hint, label),
      ));
}

// build text field
Widget buildTextFields(
  BuildContext context,
  String label,
  String hint,
  Function function,
  FocusNode node,
  FocusNode nextNode,
  TextEditingController controller,
  double size,
) {
  return Container(
    width: size,
    child: TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return '*required';
        } else if (value.contains(new RegExp(r'[a-zA-z]')) == false) {
          return 'only contains alphabets';
        } else {
          return null;
        }
      },
      onTap: function,
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

// text field for contact number
Widget contactField(
    BuildContext context,
    String label,
    String hint,
    Function function,
    FocusNode node,
    FocusNode nextNode,
    TextEditingController controller,
    double size) {
  return Container(
    width: size,
    child: TextFormField(
        keyboardType: TextInputType.number,
        onTap: function,
        controller: controller,
        focusNode: node,
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          } else if (value.contains(RegExp(r'[a-zA-z-_!@#]'))) {
            return 'invalid input';
          } else if (value.length < 10) {
            return 'must be of 10 digits';
          }
          return null;
        },
        onFieldSubmitted: (term) {
          node.unfocus();
          FocusScope.of(context).requestFocus(nextNode);
        },
        cursorColor: cursorColor,
        decoration: fieldsInputDecoration(hint, label)),
  );
}

// text field for price
Widget integerField(
    BuildContext context,
    String label,
    String hint,
    Function function,
    FocusNode node,
    FocusNode nextNode,
    TextEditingController controller,
    double size) {
  return Container(
    width: size,
    child: TextFormField(
        keyboardType: TextInputType.number,
        onTap: function,
        controller: controller,
        focusNode: node,
        validator: (value) {
          if (value.isEmpty) {
            return '*required';
          } else if (value.contains(RegExp(r'[a-zA-z-_!@#]'))) {
            return 'invalid input';
          } else {
            return null;
          }
        },
        onFieldSubmitted: (term) {
          node.unfocus();
          FocusScope.of(context).requestFocus(nextNode);
        },
        cursorColor: cursorColor,
        decoration: fieldsInputDecoration('800/day', 'Price')),
  );
}

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: Container(
      child: Container(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Image(
                image: AssetImage('images/Graphic Design.png'),
                fit: BoxFit.fill,
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Image(
                    image: AssetImage('images/profile.png'),
                    height: 25,
                    width: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'User Profile',
                      style: (TextStyle(fontSize: 18)),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserProfile()));
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Row(
                children: [
                  Image(
                    image: AssetImage('images/edit.png'),
                    height: 23,
                    width: 23,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Edit Profile',
                      style: (TextStyle(fontSize: 18)),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Row(
                children: [
                  Image(
                    image: AssetImage('images/rotation-lock.png'),
                    height: 25,
                    width: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Reset Password',
                      style: (TextStyle(fontSize: 18)),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()));
              },
            ),
            SizedBox(height: 40),
            ListTile(
              leading: FlatButton(
                padding: EdgeInsets.zero,
                onPressed: null,
                child: buildButton('Sign Out', 250),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildAvatar() {
  return Center(
    child: Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 2,
              color: Color.fromRGBO(220, 220, 220, 100),
            ),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 10))
            ],
            shape: BoxShape.rectangle,
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('images/avatar.png')),
          ),
        ),
      ],
    ),
  );
}

// widget function to build the card bodies
Widget buildUserBodyCard(
    AsyncSnapshot snapshot, index, BuildContext context, Function press) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0, top: 15, right: 5),
    child: GestureDetector(
      onTap: press,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  '${snapshot.data[index]["image"]}',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, right: 15, left: 15, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      snapshot.data[index]["vehicle_brand"] +
                          '  ' +
                          snapshot.data[index]["vehicle_model"],
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(height: 5),
                  Text('Booking Date:  ' + snapshot.data[index]["pick_up_date"],
                      style: Theme.of(context).textTheme.headline2),
                  SizedBox(height: 5),
                  Text(
                      'Booking Time:  ' +
                          snapshot.data[index]["pick_up_time"].toString(),
                      style: Theme.of(context).textTheme.headline2),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// widget function to build the card bodies
Widget buildPostedVehiclesBodyCard(
    AsyncSnapshot snapshot, index, BuildContext context, Function press) {
  print(snapshot.data[index]["vehicleImage"]);
  return Padding(
    padding: const EdgeInsets.only(left: 5.0, top: 25, right: 5),
    child: GestureDetector(
      onTap: press,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  'http://192.168.100.67:8000${snapshot.data[index]["vehicleImage"]}',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, right: 15, left: 15, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      snapshot.data[index]["brand"] +
                          '  ' +
                          snapshot.data[index]["model"],
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(height: 6),
                  Text(
                      'Plate Number:  ' + snapshot.data[index]["licenseNumber"],
                      style: Theme.of(context).textTheme.headline2),
                  SizedBox(height: 6),
                  Text(
                      'Category:  ' +
                          snapshot.data[index]["category"].toString(),
                      style: Theme.of(context).textTheme.headline2),
                  SizedBox(height: 6),
                  Text(
                      'Rate:  Rs ' +
                          snapshot.data[index]["price"].toString() +
                          '/day',
                      style: Theme.of(context).textTheme.headline2),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
