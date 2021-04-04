import 'package:easy_travel/services/tokenstorage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// get speific booking details
getBooking(String id) async {
  String token = await readContent();
  final response = await http.get(
    'http://192.168.100.67:8000/api/getbooking/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

// get booking of user which has already been conducted
getPastBookings() async {
  String token = await readContent();
  final response = await http.get(
    'http://192.168.100.67:8000/api/pastbookings',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

// get booking details of user which is yet to be conducted
getFutureBookings() async {
  String token = await readContent();
  final response = await http.get(
    'http://192.168.100.67:8000/api/futurebookings',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

// get details of vehicles which are registered by the user
getPostedVehicles() async {
  String token = await readContent();
  final response = await http.get(
    'http://192.168.100.67:8000/api/postedvehicles',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

getRequestedBooking() async {
  String token = await readContent();
  final response = await http.get(
    'http://192.168.100.67:8000/api/postbookingrequest',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception();
  }
}
