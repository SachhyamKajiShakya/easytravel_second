import 'package:flutter/material.dart';
import 'dart:io';

const fieldtext = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    color: Color.fromRGBO(125, 125, 125, 1));

const boxDecoration = BoxDecoration(
  color: Color.fromRGBO(244, 244, 244, 100),
  borderRadius: BorderRadius.all(Radius.circular(8)),
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
            TextStyle(fontFamily: 'Cambria', color: Colors.white, fontSize: 20),
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
    function, context, node, nextNode, controller, hintText, size) {
  return Container(
    height: 45,
    width: size.width * 0.15,
    decoration: boxDecoration,
    child: TextFormField(
      keyboardType: TextInputType.number,
      onTap: function,
      validator: (value) {
        if (value.isEmpty) {
          return '*';
        } else if (value.length > 2) {
          return 'invalid';
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
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: '$hintText',
          hintStyle: fieldtext),
    ),
  );
}

// build text field
Widget buildBookingTextFields(
    BuildContext context,
    Function function,
    FocusNode node,
    FocusNode nextNode,
    TextEditingController controller,
    String hintText,
    Size size,
    double width) {
  return Container(
    height: 45,
    width: size.width * width,
    decoration: boxDecoration,
    child: TextFormField(
      focusNode: node,
      onFieldSubmitted: (term) {
        node.unfocus();
        FocusScope.of(context).requestFocus(nextNode);
      },
      controller: controller,
      onTap: function,
      validator: (value) {
        if (value.isEmpty) {
          return '*required';
        } else if (value.contains(RegExp(r'[0-9]'))) {
          return 'invalid';
        } else if (value.contains('-_./#!^&*,?|')) {
          return 'invalid';
        }
        return null;
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

// pick up booking fields rows
Widget formRow(String title, Widget function) {
  return Column(children: [
    Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15),
        ),
      ],
    ),
    SizedBox(height: 15),
    Row(
      children: [function],
    ),
  ]);
}
