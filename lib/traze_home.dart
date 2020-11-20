import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traze/traze_about_covid.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/traze_appointment.dart';
import 'package:traze/traze_bluetooth.dart';
import 'package:traze/traze_broadcast.dart';
import 'package:traze/traze_input_test.dart';
import 'package:traze/traze_login.dart';
import 'package:traze/traze_positive_scan.dart';
import 'package:traze/traze_screening.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController _controller;

  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(34.0522, 118.2437));

  final List<Marker> markers = [];

  addMarker(cordinate) {
    int id = Random().nextInt(100);

    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: markers.toSet(),
        onTap: (cordinate) {
          _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
          addMarker(cordinate);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.animateCamera(CameraUpdate.zoomOut());
        },
        child: Icon(Icons.zoom_out),
      ), // This trailing comma makes
      appBar: AppBar(
        title: Text('Heat Map'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                  Colors.deepOrangeAccent,
                  Colors.orangeAccent,
                ])),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        elevation: 10.0,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/Transparent_Waze.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Traze',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      )
                    ],
                  ),
                )),
            CustomListTile(Icons.person, 'About Covid', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutCovid()));
            }),
            CustomListTile(Icons.account_circle, 'Make an Appointment', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Appointment()));
            }),
            CustomListTile(Icons.wifi, 'Heatmap', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }),
            CustomListTile(Icons.check, 'Self Screening', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LandingPage()));
            }),
            CustomListTile(Icons.bluetooth, 'Scan for Devices', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Bluetooth()));
            }),
            CustomListTile(Icons.airplay_rounded, 'Broadcast', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Broadcast()));
            }),
            CustomListTile(Icons.clear, 'Positive Scan Message', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PositiveScan()));
            }),
            CustomListTile(Icons.assignment_ind_outlined, 'Your Test ID', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TestID()));
            }),
          ],
        ),
      ),
      // auto-formatting nicer for build methods.
    );
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
        ),
        child: InkWell(
          splashColor: Colors.orangeAccent,
          onTap: onTap,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
