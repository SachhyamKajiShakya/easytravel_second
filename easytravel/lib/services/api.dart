import 'dart:io';
import 'package:easy_travel/screens/navbar.dart';
import 'package:easy_travel/screens/profile/userprofile.dart';
import 'package:easy_travel/screens/registervehicles/registerVehicle.dart';
import 'package:easy_travel/screens/userAuthentication/login.dart';
import 'package:easy_travel/screens/userAuthentication/otp.dart';
import 'package:easy_travel/screens/userAuthentication/signup.dart';
import 'package:easy_travel/services/tokenstorage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'fcmservices.dart';
import 'package:easy_travel/screens/registervehicles/assigndriver.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// future method to login user
Future<String> loginUser(String email, String password, context) async {
  FirebaseMessaging _firebasemsg = FirebaseMessaging();
  final http.Response response = await http.post(
    'http://192.168.100.67:8000/api/login/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, dynamic>{
        'username': email,
        'password': password,
      },
    ),
  );
  if (response.statusCode == 200) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VehicleRegistrationPage()));
    String token = jsonDecode(response.body)['token'].toString();
    writeContent(token);
    _firebasemsg.getToken().then((devicetoken) async {
      print('device token: ' + devicetoken);
    });
    return token;
  } else {
    throw Exception('Failed to laod');
  }
}

// future method to create user
createUser(String email, String username, String password, String password2,
    String name, String phone, context) async {
  final http.Response response = await http.post(
    'http://192.168.100.67:8000/api/register/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      //setting values to be added in the body
      <String, String>{
        'email': email,
        'username': username,
        'password': password,
        'password2': password2,
        'name': name,
        'phone': phone,
      },
    ),
  );
  //if new user is created then navigate user to home page else throw exception
  if (response.statusCode == 200) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VehicleRegistrationPage()));
    String token = jsonDecode(response.body)['token'].toString();
    writeContent(token);
    getDeviceToken();
  } else {
    throw Exception('Failed to laod');
  }
}

// api for making booking request for short travel
makeLongBookings(
    String province,
    String days,
    String date,
    String time,
    String district,
    String city,
    String street,
    String destinationProvince,
    String destinationDistrict,
    String destinationCity,
    String destinationStreet,
    String vehicleid,
    String driverid,
    context) async {
  try {
    String token = await readContent();

    String url =
        'http://192.168.100.67:8000/api/longbooking/$vehicleid/$driverid/';

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(
        <String, String>{
          'pick_up_province': province,
          'number_of_days': days,
          'pick_up_date': date,
          'pick_up_time': time,
          'pick_up_district': district,
          'pick_up_city': city,
          'pick_up_street': street,
          'destination_province': destinationProvince,
          'destination_district': destinationDistrict,
          'destination_city': destinationCity,
          'destination_street': destinationStreet,
        },
      ),
    );
    if (response.statusCode == 200) {
      _sendNotification(vehicleid, context);
    } else {
      throw Exception();
    }
  } catch (e) {
    print(e);
  }
}

// function to send booking notification to the vendor
_sendNotification(String vehicleid, context) async {
  String token = await readContent();
  final response = await http.post(
    'http://192.168.100.67:8000/api/fcm/$vehicleid',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  if (response.statusCode == 200) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NavBarPage()));
  } else {
    print('notification not success');
  }
}

// api for making booking request for long travels
makeShortbookings(
    String date,
    String time,
    String district,
    String city,
    String street,
    String destinationDestrict,
    String destinationCity,
    String destinationStreet,
    String vehicleid,
    String driverid,
    context) async {
  try {
    String token = await readContent();
    final http.Response response = await http.post(
      'http://192.168.100.67:8000/api/shortbooking/$vehicleid/$driverid/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(
        <String, String>{
          'pick_up_date': date,
          'pick_up_time': time,
          'pick_up_district': district,
          'pick_up_city': city,
          'pick_up_street': street,
          'destination_district': destinationDestrict,
          'destination_city': destinationCity,
          'destination_street': destinationStreet,
        },
      ),
    );
    if (response.statusCode == 200) {
      _sendNotification(vehicleid, context);
    } else {
      print('booking unsuccessful');
    }
  } catch (e) {
    print(e);
  }
}

enterOtp(String otp, String phoneNumber, BuildContext context) async {
  final http.Response response = await http.post(
    // 'https://fyp-easytravel.herokuapp.com/api/otp/',
    'http://192.168.100.67:8000/api/otp/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, String>{
        'otp': otp,
      },
    ),
  );
  if (response.statusCode == 200) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignupPage(phoneNumber: phoneNumber)));
  } else {
    throw Exception('Process Failed');
  }
}

enterPhone(String phone, BuildContext context) async {
  final http.Response response = await http.post(
    // 'https://fyp-easytravel.herokuapp.com/api/phoneNumber/',
    'http://192.168.100.67:8000/api/phoneNumber/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, String>{
        'phone': phone,
      },
    ),
  );
  if (response.statusCode == 200) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OTP(
                  phoneNumber: phone,
                )));
  } else {
    throw Exception('Process Failed');
  }
}

Dio _dio = Dio();
//api to upload data
uploadVehicleData(
  String brand,
  String model,
  String licenseNumber,
  String category,
  String service,
  String description,
  int price,
  File vehicleImage,
  File bluebookImage,
  context,
) async {
  try {
    String token = await readContent();
    String vehicleFileName = vehicleImage.path.split('/').last;
    String bluebookFileName = bluebookImage.path.split('/').last;

    FormData formData = FormData.fromMap({
      'brand': brand,
      'model': model,
      'licenseNumber': licenseNumber,
      'category': category,
      'service': service,
      'description': description,
      'price': price,
      'vehicleImage': await MultipartFile.fromFile(vehicleImage.path,
          filename: vehicleFileName),
      'bluebookImage': await MultipartFile.fromFile(bluebookImage.path,
          filename: bluebookFileName),
    });

    final response = await _dio.post('http://192.168.100.67:8000/api/vehicle/',
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {'Authorization': 'Token $token'}));
    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AssignDriver()));
    } else {
      print('error file uploading to server');
    }
  } catch (e) {
    print(e + 'error file uploading to server');
  }
}

//api to upload data
uploadDriverData(
  String driverName,
  String driverContact,
  String driverAddress,
  File licenseImage,
  BuildContext context,
) async {
  try {
    String token = await readContent();
    String licenseFileName = licenseImage.path.split('/').last;
    FormData formData = new FormData.fromMap({
      'driverName': driverName,
      'driverAddress': driverAddress,
      'driverContact': driverContact,
      'licenseImage': await MultipartFile.fromFile(licenseImage.path,
          filename: licenseFileName)
    });
    final response = await _dio.post('http://192.168.100.67:8000/api/driver/',
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {'Authorization': 'Token $token'}));
    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavBarPage()));
    } else {
      print('error uploading file');
    }
  } catch (e) {
    print(e);
  }
}

// get method to obtain details of the users
getUserData() async {
  String token = await readContent();
  final response = await http.get('http://192.168.100.67:8000/api/getuserdata',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      });
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return Exception();
  }
}

// function to update user password
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserProfile()));
  } else {
    return Exception();
  }
}

// function for signing out of user
userLogout(BuildContext context) async {
  String token = await readContent();
  final response = await http
      .post('http://192.168.100.67:8000/api/logout/', headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $token',
  });
  if (response.statusCode == 200) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  } else {
    print("error signing out");
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
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Success'),
            content: SingleChildScrollView(
              child: Text('Your data was successfully updated.'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Okay'),
              ),
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Unsuccess'),
            content: SingleChildScrollView(
              child: Text('Your data was not updated.'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Okay'),
              ),
            ],
          );
        });
  }
}
