import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

sendConfirmnotification(String id) async {
  print(id);
  String token = await readContent();
  final response = await http.post(
    'http://192.168.100.67:8000/api/confirmmessage/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    print("sent notification");
  } else {
    print('unsuccesfull');
  }
}

sendCancelnotification(String id) async {
  String token = await readContent();
  final response = await http.post(
    'http://192.168.100.67:8000/api/cancelmessage/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    print("sent notification");
  } else {
    print('unsuccesfull');
  }
}
