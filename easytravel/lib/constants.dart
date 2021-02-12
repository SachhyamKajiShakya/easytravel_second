import 'package:flutter/material.dart';
import 'dart:io';

// Widget method to build header
Widget buildHeader(BuildContext context) {
  return Text(
    'Easy Travel',
    style: TextStyle(
        fontFamily: 'Cambria', fontSize: 60, fontWeight: FontWeight.w500),
  );
}

// Widget method to build subheader
Widget buildSubHeader(String text) {
  return Text(
    '$text',
    style: TextStyle(
        fontFamily: 'Cambria', fontSize: 35, fontWeight: FontWeight.w500),
  );
}

// Widget method to build rest of the buttons
Widget buildButton(String text) {
  return Container(
    width: 312,
    height: 45,
    decoration: BoxDecoration(
      color: Color.fromRGBO(250, 232, 232, 1),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Center(
      child: Text(
        '$text',
        style: TextStyle(
            fontFamily: 'Cambria',
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}

// widget method to build text fields
Widget buildTextField(FocusNode node, FocusNode nextNode, String hintText,
    TextEditingController _controller, context) {
  return Container(
    height: 45,
    width: 350,
    decoration: BoxDecoration(
      color: Color.fromRGBO(244, 244, 244, 100),
      borderRadius: BorderRadius.all(Radius.circular(29)),
    ),
    child: TextFormField(
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
        hintStyle: TextStyle(
            fontFamily: 'Cambria',
            fontSize: 15,
            color: Color.fromRGBO(125, 125, 125, 1)),
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
              border: Border.all(color: Color.fromRGBO(125, 125, 125, 1))),
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
                      fontFamily: 'Cambria',
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
      padding: const EdgeInsets.only(left: 15.0, top: 20, right: 15),
      child: GestureDetector(
        onTap: press,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'http://192.168.100.67:8000${snapshot.data[index]["vehicleImage"]}',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 8.0),
              child: Text(
                  snapshot.data[index]["brand"] +
                      ' ' +
                      snapshot.data[index]["model"],
                  style: Theme.of(context).textTheme.headline4),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 3.0),
              child: Text(
                  'Rs ' + snapshot.data[index]["price"].toString() + '/km',
                  style: Theme.of(context).textTheme.headline3),
            ),
          ],
        ),
      ),
    ),
  );
}
