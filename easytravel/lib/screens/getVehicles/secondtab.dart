import 'package:easy_travel/screens/getVehicles/detailscreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_travel/services/vehicleapi.dart';
import 'package:easy_travel/constants.dart';

class SecondTabPage extends StatefulWidget {
  @override
  _SecondTabPageState createState() => _SecondTabPageState();
}

class _SecondTabPageState extends State<SecondTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: getLongVehicles(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: Text('loading'));
            } else {
              return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) => buildBodyCard(
                    snapshot,
                    index,
                    context,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreenPage(
                                snapshot: snapshot, index: index)))),
              );
            }
          }),
    );
  }
}
