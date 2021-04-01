import 'dart:convert';
import 'package:easy_travel/screens/profilewidgets.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// method to call api for changing password
updatePassword(
    String oldpassword, String newpassword, BuildContext context) async {
  String token = await readContent();
  final response = await http.put(
    'http://192.168.100.67:8000/api/updatepassword',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: json.encode(
      <String, String>{
        "oldpassword": oldpassword,
        "newpassword": newpassword,
      },
    ),
  );
  if (response.statusCode == 200) {
    buildSuccessDialogBox(
      context,
      'Update Success',
      'Your data was succeessfulyl updated',
    );
  } else {
    buildFailDialogBox(context, 'Error', 'Your current password do not match');
  }
}

// function to update user information
updateUserData(String name, String email, String username, String contact,
    BuildContext context) async {
  String token = await readContent();
  final response = await http.put(
    'http://192.168.100.67:8000/api/updateuser/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: json.encode(<String, String>{
      "name": name,
      "email": email,
      "username": username,
      "phone": contact,
    }),
  );
  if (response.statusCode == 200) {
    buildSuccessDialogBox(
        context, 'Update Success', 'Your data was successfully updated');
  } else {
    buildFailDialogBox(context, 'Error', 'Your data was not uplaoded');
  }
}

// function to update vehicle details
updateVehicleDetials(
    String brand,
    String model,
    String licensePlateNumber,
    String category,
    String service,
    String description,
    int price,
    int vehicleid,
    BuildContext context,
    String driverName,
    String driverAddress,
    String driverContact,
    int driverid) async {
  String token = await readContent();
  final response = await http.put(
    'http://192.168.100.67:8000/api/managevehicles/$vehicleid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: json.encode(<String, dynamic>{
      "brand": brand,
      "model": model,
      "licenseNumber": licensePlateNumber,
      "category": category,
      "service": service,
      "description": description,
      "price": price,
    }),
  );
  if (response.statusCode == 200) {
    updateDriverDetails(
        driverName, driverAddress, driverContact, driverid, context);
  } else {
    updateDriverDetails(
        driverName, driverAddress, driverContact, driverid, context);
  }
}

// function to update driver details
updateDriverDetails(String driverName, String driverAddress,
    String driverContact, int driverid, BuildContext context) async {
  String token = await readContent();
  final response = await http.put(
    'http://192.168.100.67:8000/api/driver/$driverid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: json.encode(<String, dynamic>{
      "driverName": driverName,
      "driverAddress": driverAddress,
      "driverContact": driverContact,
    }),
  );
  if (response.statusCode == 200) {
    buildSuccessDialogBox(
        context, 'Update Success', 'Your data was successfully updated');
  } else {
    buildFailDialogBox(context, 'Error', 'Your data was not updated');
  }
}
