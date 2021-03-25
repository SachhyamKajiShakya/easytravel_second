import 'package:easy_travel/services/tokenstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

getDeviceToken() {
  _firebaseMessaging.getToken().then((token) async {
    String userToken = await readContent();
    http.Response response = await http.post(
      'http://192.168.100.67:8000/api/storedevicetoken/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $userToken',
      },
      body: jsonEncode(
        <String, String>{
          'device_token': token,
        },
      ),
    );
    if (response.statusCode == 200) {
      print(token);
      return response.body;
    } else {
      throw Exception('Failed to send token');
    }
  });
}
