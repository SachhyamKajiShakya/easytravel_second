import 'package:easy_travel/services/tokenstorage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
