import 'package:easy_travel/services/tokenstorage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

getShortVehicles() async {
  String token = await readContent();
  print(token);
  final response = await http.get(
    // 'https://fyp-easytravel.herokuapp.com/api/vehicle/short',
    'http://192.168.100.67:8000/api/vehicle/short',
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

getLongVehicles() async {
  String token = await readContent();
  final response = await http.get(
    // 'https://fyp-easytravel.herokuapp.com/api/vehicle/long',
    'http://192.168.100.67:8000/api/vehicle/long',
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

getDriverDetails(int id) async {
  String token = await readContent();
  final response = await http.get(
    // 'https://fyp-easytravel.herokuapp.com/api/driver/$id',
    'http://192.168.100.67:8000/api/driver/$id',
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
