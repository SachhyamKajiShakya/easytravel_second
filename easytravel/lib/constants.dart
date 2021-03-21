import 'package:flutter/material.dart';
import 'dart:io';

const fieldtext = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    color: Color.fromRGBO(125, 125, 125, 1));

const boxDecoration = BoxDecoration(
  color: Color.fromRGBO(230, 230, 230, 100),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

BoxDecoration iconBoxDecoration = BoxDecoration(
  shape: BoxShape.circle,
  border: Border.all(
    width: 2,
    color: Colors.white,
  ),
  color: Colors.redAccent,
);

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

const headerIcon = Icon(
  Icons.arrow_back_outlined,
  size: 22,
  color: Colors.black,
);

const textSpan = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 17,
  color: Colors.red,
);

TextStyle labelstyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.6,
    color: Colors.black);

TextStyle hintstyle = TextStyle(
  fontSize: 16,
  color: Colors.blueGrey,
);

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
      color: Colors.redAccent,
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

// widget method to build text fields
Widget buildTextField(Function onTap, FocusNode node, FocusNode nextNode,
    String hintText, TextEditingController _controller, context) {
  return Container(
    height: 45,
    width: 350,
    decoration: boxDecoration,
    child: TextFormField(
      onTap: onTap,
      validator: (value) {
        if (value.isEmpty) {
          return '*required';
        }
        return null;
      },
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
          elevation: 0.5,
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
      controller: controller,
      focusNode: node,
      onFieldSubmitted: (term) {
        node.unfocus();
        FocusScope.of(context).requestFocus(nextNode);
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
        labelText: label,
        labelStyle: labelstyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: hintstyle,
      ),
    ),
  );
}

// build text field
Widget buildBookingTextFields(
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
      controller: controller,
      focusNode: node,
      onFieldSubmitted: (term) {
        node.unfocus();
        FocusScope.of(context).requestFocus(nextNode);
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(210, 210, 210, 1))),
        contentPadding: EdgeInsets.only(bottom: 3, left: 8, top: 3),
        labelText: label,
        labelStyle: labelstyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: hintstyle,
      ),
    ),
  );
}

Widget profilePicture(String alternateText, File image, Function function) {
  return image != null
      ? Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
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
              ),
              child: Image.file(image),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  color: Colors.redAccent,
                ),
                child: Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ],
        )
      : Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
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
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  color: Colors.redAccent,
                ),
                child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      function();
                    }),
              ),
            ),
          ],
        );
}
