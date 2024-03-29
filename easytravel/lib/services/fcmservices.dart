import 'package:easy_travel/screens/profilewidgets.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

// assigning device token for the device
getDeviceToken(context) {
  _firebaseMessaging.getToken().then((devicetoken) async {
    String token = await readContent();
    http.Response response = await http.post(
      'http://192.168.100.67:8000/api/storedevicetoken/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(
        <String, String>{
          'device_token': devicetoken,
        },
      ),
    );
    if (response.statusCode == 200) {
      return devicetoken;
    } else {
      buildDialogBox(context, 'Failed', 'User already exists', 'Okay');
    }
  });
}

// updating device token on login
updateDeviceToken() {
  _firebaseMessaging.getToken().then(
    (devicetoken) async {
      String token = await readContent();
      final response = await http.put(
        'http://192.168.100.67:8000/api/updatedevicetoken',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: json.encode(<String, String>{
          "device_token": devicetoken,
        }),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('error');
      }
    },
  );
}
