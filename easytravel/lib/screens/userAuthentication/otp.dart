// // https://stackoverflow.com/questions/50818770/passing-data-to-a-stateful-widget
// import 'package:easy_travel/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_otp/flutter_otp.dart';

// class OTPSection extends StatefulWidget {
//   final String phoneNumber;

//   const OTPSection({this.phoneNumber});
//   @override
//   _OTPSectionState createState() => _OTPSectionState();
// }

// class _OTPSectionState extends State<OTPSection> {
//   FlutterOtp otp = FlutterOtp();
//   TextEditingController _otpController;
//   int enteredOtpCode;

//   // void generateOtp([int min = 1000, int max = 9999]) {
//   //   _minOtpValue = min;
//   //   _maxOtpValue = max;
//   //   generatedOtp = _minOtpValue + Random().nextInt(_maxOtpValue - _minOtpValue);
//   // }

//   // void resultChecker(enteredOtpCode) {
//   //   if (enteredOtpCode == generatedOtp) {
//   //     print('true');
//   //   } else {
//   //     print('false');
//   //   }
//   // }

//   void initState() {
//     // otp.sendOtp(widget.phoneNumber);
//     otp.sendOtp(widget.phoneNumber);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomInset: false,
//         resizeToAvoidBottomPadding: false,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 45,
//                     width: 350,
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(244, 244, 244, 100),
//                       borderRadius: BorderRadius.all(Radius.circular(29)),
//                     ),
//                     child: TextFormField(
//                       onChanged: (value) {
//                         enteredOtpCode = int.parse(value);
//                       },
//                       textAlign: TextAlign.center,
//                       cursorColor: Colors.black,
//                       controller: _otpController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                         hintText: 'OTP',
//                         hintStyle: TextStyle(
//                             fontFamily: 'Cambria',
//                             fontSize: 15,
//                             color: Color.fromRGBO(125, 125, 125, 1)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   FlatButton(
//                     onPressed: () {
//                       print(widget.phoneNumber);
//                       print(otp.resultChecker(enteredOtpCode));
//                       print('entered otp code' + enteredOtpCode.toString());
//                     },
//                     child: buildButton('Submit'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
