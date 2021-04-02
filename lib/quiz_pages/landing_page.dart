import 'package:flutter/material.dart';

import 'package:traze/quiz_pages/quiz_page.dart';

import '../traze_about_covid.dart';
import '../traze_appointment.dart';
import '../traze_bluetooth.dart';
import '../traze_heat_map.dart';
import '../traze_input_test.dart';
import '../traze_positive_scan.dart';
import 'package:traze/uuid_scan_2.dart';
import 'package:traze/beacon_broadcast_2.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Material(
        color: Colors.orangeAccent,
        child: new InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new QuizPage())),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Start your self-screening',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold),
              ),
              new Text(
                'Tap to Start!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Self Screening'),
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
                            width: 70,
                            height: 70,
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
                  context, MaterialPageRoute(builder: (context) => HeatMap()));
            }),
            CustomListTile(Icons.check, 'Self Screening', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LandingPage()));
            }),
            CustomListTile(Icons.bluetooth, 'Scan for Devices', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FlutterBlueApp()));
            }),
            CustomListTile(Icons.airplay_rounded, 'Broadcast', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BroadcastTwo()));
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
