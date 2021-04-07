import 'package:flutter/material.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/traze_about_covid.dart';
import 'package:traze/traze_appointment.dart';
import 'package:traze/traze_heat_map.dart';
import 'package:traze/traze_input_test.dart';
import 'package:traze/traze_status.dart';

import 'CovidAPI/homepage.dart';
import 'Google/Screens/home.dart';
import 'beacon_broadcast_2.dart';
import 'beacon_broadcast_scan.dart';

class PositiveScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contact Status'),
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
                    MaterialPageRoute(builder: (context) => APIHome()));
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
        ),
        backgroundColor: Colors.red,
        body: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'You have been in contact with somebody who has tested positive for Covid 19. Push the button below to make an appointment to get tested.',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  backgroundColor: Colors.red,
                ),
              ),
              new IconButton(
                icon: new Icon(Icons.arrow_right),
                color: Colors.white,
                iconSize: 50.0,
                onPressed: () {},
              )
            ],
          ),
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
