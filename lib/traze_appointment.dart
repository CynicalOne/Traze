import 'package:flutter/material.dart';
import 'package:traze/Google/Screens/home.dart';
import 'package:traze/beacon_broadcast_scan.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/traze_about_covid.dart';
import 'package:traze/traze_bluetooth.dart';
import 'package:traze/traze_broadcast.dart';
import 'package:traze/traze_heat_map.dart';
import 'package:traze/traze_input_test.dart';
import 'package:traze/traze_login.dart';
import 'package:traze/traze_positive_scan.dart';
import 'package:traze/traze_screening.dart';
import 'package:traze/traze_status.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:traze/uuid_scan_2.dart';
import 'beacon_broadcast_2.dart';

class Appointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: Container(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 400,
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/Transparent_Waze.png',
                            width: 90,
                            height: 90,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'If you have experienced any symptoms and have taken our self screening quiz, or have come into contact with someone who has tested positive for covid, please make an appointment at the link below.',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 250,
                        child: RaisedButton(
                          //link to appointment url when pressed
                          onPressed: _launchURL,
                          color: Colors.orange,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Text(
                            'schedule appointment',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Make an Appointment'),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                  )),
              CustomListTile(Icons.account_circle, 'Profile', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              }),
              CustomListTile(Icons.person, 'About Covid', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutCovid()));
              }),
              CustomListTile(Icons.wifi, 'Heatmap', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrazeMap()));
              }),
              CustomListTile(Icons.check, 'Self Screening', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LandingPage()));
              }),
              CustomListTile(Icons.bluetooth, 'Scan for Devices', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BeaconScan()));
              }),
              CustomListTile(Icons.airplay_rounded, 'Broadcast', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BroadcastTwo()));
              }),
              CustomListTile(Icons.clear, 'Positive Scan Message', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactStatus()));
              }),
              CustomListTile(Icons.assignment_ind_outlined, 'Your Test ID', () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => TestID()));
              }),
            ],
          ),
        ));
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

_launchURL() async {
  const url =
      'https://www.hhs.gov/coronavirus/community-based-testing-sites/index.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
