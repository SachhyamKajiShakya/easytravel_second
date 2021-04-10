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
    buildDialogBox(context, 'Update Success',
        'Your data was succeessfulyl updated', 'Okay');
  } else {
    buildDialogBox(
        context, 'Error', 'Your current password do not match', 'Okay');
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
    buildDialogBox(context, 'Update Success',
        'Your data was successfully updated.', 'Okay');
  } else {
    buildDialogBox(context, 'Error', 'Your data was not uplaoded.', 'Okay');
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
    buildDialogBox(context, 'Update Success',
        'Your driver data was successfully updated.', 'Okay');
  } else {
    buildDialogBox(
        context, 'Error', 'Your driver data was not updated.', 'Okay');
  }
}

// function that call api to delete specific vehicle
deleteVehicle(int vehicleid, BuildContext context) async {
  String token = await readContent();
  final response = await http.delete(
    'http://192.168.100.67:8000/api/managevehicles/$vehicleid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    buildDialogBox(
        context, 'Delete Success', 'The vehicle was delete.', 'Okay');
  } else {
    buildDialogBox(context, 'Fail', 'The vehicle was not deleted.', 'Okay');
  }
}

// function that calls api to cancel a confirmed booking
cancelBooking(int bookingid, BuildContext context) async {
  String token = await readContent();
  final response = await http.post(
    'http://192.168.100.67:8000/api/cancelbooking/$bookingid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    buildDialogBox(context, 'Booking Cancelled',
        'The booking has been cancelled.', 'Okay');
  } else {
    buildDialogBox(context, 'Failed', 'Failed to cancel the booking,', 'Okay');
  }
}

// function that calls api to update short booking
updateShortBooking(
    int bookingid,
    String district,
    String city,
    String street,
    String date,
    String time,
    String destinationDistrict,
    String destinationCity,
    String destinationStreet,
    BuildContext context) async {
  String token = await readContent();
  final response = await http.put(
    'http://192.168.100.67:8000/api/updateshortbookings/$bookingid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: json.encode(<String, String>{
      "pick_up_district": district,
      "pick_up_city": city,
      "pick_up_street": street,
      "pick_up_date": date,
      "pick_up_time": time,
      "destination_district": destinationDistrict,
      "destination_city": destinationCity,
      "destination_street": destinationStreet,
    }),
  );
  if (response.statusCode == 200) {
    buildDialogBox(
        context, 'Booking Updated', 'The booking has been updated.', 'Okay');
  } else {
    buildDialogBox(context, 'Failed', 'Failed to update the booking.', 'Okay');
  }
}

// funciton that calls api to update long bookings
updateLongBooking(
    int bookingid,
    String pickupProvince,
    String pickupDistrict,
    String pickupCity,
    String pickupStreet,
    String date,
    String time,
    String destinationProvince,
    String destinationDistrict,
    String destinationCity,
    String destinationStreet,
    int days,
    BuildContext context) async {
  String token = await readContent();
  final response = await http.put(
    'http://192.168.100.67:8000/api/updatelongbookings/$bookingid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: json.encode(<String, dynamic>{
      "pick_up_province": pickupProvince,
      "pick_up_district": pickupDistrict,
      "pick_up_city": pickupCity,
      "pick_up_street": pickupStreet,
      "pick_up_date": date,
      "pick_up_time": time,
      "destination_province": destinationProvince,
      "destination_district": destinationDistrict,
      "destination_city": destinationCity,
      "destination_street": destinationStreet,
      "number_of_days": days,
    }),
  );
  if (response.statusCode == 200) {
    buildDialogBox(
        context, 'Booking Updated', 'The booking has been updated', 'Okay');
  } else {
    buildDialogBox(context, 'Failed', 'Failed to update the booking', 'Okay');
  }
}
