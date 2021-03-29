import 'package:easy_travel/constants.dart';
import 'package:easy_travel/screens/bookings/longtravel.dart';
import 'package:easy_travel/screens/bookings/shorttravel.dart';
import 'package:easy_travel/services/vehicleapi.dart';
import 'package:flutter/material.dart';

class DetailScreenPage extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final index;

  const DetailScreenPage({Key key, this.snapshot, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        body: FutureBuilder(
          future: getDriverDetails(snapshot.data[index]["id"]),
          builder: (context, datasnapshot) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, dataindex) {
                if (datasnapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              _buildImage(size, snapshot, index),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white60,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_back_outlined,
                                            size: 24, color: Colors.black),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: size.height * 0.55,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                              topRight: Radius.circular(70)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: Column(
                            children: [
                              _buildFirstRow(snapshot, index, context),
                              SizedBox(height: 25),
                              _buildSecondRow(context),
                              SizedBox(height: 10),
                              _buildThirdRow(snapshot, index, context, size),
                              SizedBox(height: 25),
                              _buildFourthRow(datasnapshot, dataindex, context),
                              SizedBox(height: 25),
                              _buildFifthRow(context),
                              SizedBox(height: 10),
                              _buildSixthRow(
                                  snapshot, dataindex, context, size),
                              SizedBox(height: 50),
                              _buildBookingButton(snapshot, index, context,
                                  datasnapshot, dataindex),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

// function to build driver details
Widget _driverDetails(String title, String value, context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.bodyText1),
      SizedBox(height: 8),
      Text(value),
    ],
  );
}

// function to build image
Widget _buildImage(size, snapshot, index) {
  return Container(
    height: 310,
    width: size.width,
    child: Image.network(
        'http://192.168.100.67:8000${snapshot.data[index]["vehicleImage"]}',
        fit: BoxFit.fill),
  );
}

// function to build brand model and price
Widget _buildFirstRow(snapshot, index, context) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(snapshot.data[index]["brand"] + ' ' + snapshot.data[index]["model"],
        style: Theme.of(context).textTheme.headline1),
    Text('Rs ' + snapshot.data[index]["price"].toString() + '/day',
        style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54)),
  ]);
}

// function to build description title
Widget _buildSecondRow(context) {
  return Row(
    children: [
      Text('Description', style: Theme.of(context).textTheme.bodyText1)
    ],
  );
}

// function to build vehicle description
Widget _buildThirdRow(snapshot, index, context, size) {
  return Row(
    children: [
      Expanded(
        child: Container(
          width: size.width,
          child: Text(
            snapshot.data[index]['description'],
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    ],
  );
}

// function to build driver name and contact
Widget _buildFourthRow(datasnapshot, dataindex, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _driverDetails(
          'Driver Name', datasnapshot.data[dataindex]['driverName'], context),
      _driverDetails('Driver Contact',
          datasnapshot.data[dataindex]['driverContact'], context),
    ],
  );
}

// function to build description title
Widget _buildFifthRow(context) {
  return Row(
    children: [
      Text('Available For', style: Theme.of(context).textTheme.bodyText1)
    ],
  );
}

// function to build vehicle description
Widget _buildSixthRow(snapshot, index, context, size) {
  return Row(
    children: [
      Expanded(
        child: Container(
          width: size.width,
          child: Text(
            snapshot.data[index]['category'],
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    ],
  );
}

Widget _buildBookingButton(snapshot, index, context, datasnapshot, dataindex) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      FlatButton(
        onPressed: () {
          if (snapshot.data[index]['category'] == 'Short Travel') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookShortTravel(
                        snapshot: snapshot,
                        datasnapshot: datasnapshot,
                        index: index,
                        dataindex: dataindex)));
          } else if (snapshot.data[index]['category'] == 'Long Travel') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookLongTravel(
                        snapshot: snapshot,
                        datasnapshot: datasnapshot,
                        index: index,
                        dataindex: dataindex)));
          }
        },
        child: buildButton('Book', 300),
      ),
    ],
  );
}
