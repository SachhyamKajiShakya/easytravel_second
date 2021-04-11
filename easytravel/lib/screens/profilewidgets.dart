import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/screens/password/changepw.dart';
import 'package:easy_travel/screens/profile/editVehicle.dart';
import 'package:easy_travel/screens/profile/editprofile.dart';
import 'package:easy_travel/screens/profile/futureBooking.dart';
import 'package:easy_travel/screens/profile/longFutureBookings.dart';
import 'package:easy_travel/services/api.dart';
import 'package:easy_travel/services/updateapi.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import '../constants.dart';

List<String> actions = <String>['Edit', 'Delete'];

// widget method to build drawer for profile
Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: Container(
      child: Container(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.only(top: 60, left: 0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/companyname.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            ListTile(
              title: Row(
                children: [
                  Image(
                    image: AssetImage('images/pin-code.png'),
                    height: 25,
                    width: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      'Change Password',
                      style: (TextStyle(fontSize: 18)),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
            ),
            SizedBox(height: 50),
            ListTile(
              leading: FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  userLogout(context);
                },
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

// widget method to build avatar for the user profile
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
                  SizedBox(height: 5),
                  Text(
                      'Amount:  Rs ' +
                          snapshot.data[index]["total_amount"].toString(),
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
Widget buildFutureBookingBodyCard(
    AsyncSnapshot snapshot, index, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0, top: 15, right: 5),
    child: FocusedMenuHolder(
      blurSize: 1,
      blurBackgroundColor: Colors.black,
      onPressed: () {},
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text('Edit'),
            onPressed: () {
              snapshot.data[index]["number_of_days"] == null
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FutureBooking(
                                snapshot: snapshot,
                                index: index,
                              )))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LongFutureBooking(
                                snapshot: snapshot,
                                index: index,
                              )));
            },
            trailingIcon: Icon(Icons.edit)),
        FocusedMenuItem(
            title: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              cancelBooking(snapshot.data[index]["id"], context);
            },
            backgroundColor: Colors.redAccent,
            trailingIcon: Icon(Icons.cancel, color: Colors.white))
      ],
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
                  SizedBox(height: 5),
                  Text(
                      'Amount:  Rs ' +
                          snapshot.data[index]["total_amount"].toString(),
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
    AsyncSnapshot snapshot, index, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0, top: 15, right: 5),
    child: FocusedMenuHolder(
      blurSize: 1,
      blurBackgroundColor: Colors.black,
      onPressed: () {},
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text('Edit'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditVehicle(
                            snapshot: snapshot,
                            index: index,
                          )));
            },
            trailingIcon: Icon(Icons.edit)),
        FocusedMenuItem(
            title: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              deleteVehicle(snapshot.data[index]["id"], context);
            },
            backgroundColor: Colors.redAccent,
            trailingIcon: Icon(Icons.delete, color: Colors.white))
      ],
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

// build text field for profile sections
Widget buildProfileTextFields(
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
        if (value.isEmpty == false &&
            value.contains(new RegExp(r'[a-zA-z]')) == false) {
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

// text field for vehicle price
Widget buildProfileIntegerField(
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
        keyboardType: TextInputType.number,
        onTap: function,
        controller: controller,
        focusNode: node,
        validator: (value) {
          if (value.isEmpty == false &&
              value.contains(RegExp(r'[0-9]')) == false) {
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
        decoration: fieldsInputDecoration(hint + '/day', label)),
  );
}

Future buildDialogBox(context, String title, String body, String buttonText) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(body),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}
