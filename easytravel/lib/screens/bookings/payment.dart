import 'package:flutter/material.dart';
import 'package:easy_travel/constants.dart';
import 'package:flutter_khalti/flutter_khalti.dart';

class PaymentGateway extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your total amount is: ",
                      style: TextStyle(fontFamily: 'Cambria', fontSize: 28))
                ],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 350,
                    decoration: boxDecoration,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: '800',
                          hintStyle: fieldtext),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: null,
                    child: buildButton('Pay via cash', 150),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: _payviaKhalti,
                    child: buildButton('Pay via khalti', 150),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// future method to build the khalti payment system
_payviaKhalti() async {
  FlutterKhalti _flutterKhalti = FlutterKhalti.configure(
    publicKey: 'test_public_key_eff1b04846c54304a510d20a9a7d589a',
    urlSchemeIOS: 'KhaltiPayFlutterExampleSchema',
    paymentPreferences: [
      KhaltiPaymentPreference.KHALTI,
    ],
  );
  KhaltiProduct product =
      KhaltiProduct(id: 'test', amount: 10000, name: 'Product');
  _flutterKhalti.startPayment(
      product: product,
      onSuccess: (data) {
        print('payment success');
      },
      onFaliure: (error) {
        print('payment unsuccessful' + '$error');
      });
}
