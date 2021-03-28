import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

sendConfirmnotification(String id, context) async {
  String token = await readContent();
  final response = await http.post(
    'http://192.168.100.67:8000/api/confirmmessage/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NavBarPage()));
  } else {
    print('unsuccesfull');
  }
}

sendCancelnotification(String id, context) async {
  String token = await readContent();
  final response = await http.post(
    'http://192.168.100.67:8000/api/cancelmessage/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NavBarPage()));
  } else {
    print('unsuccesfull');
  }
}
