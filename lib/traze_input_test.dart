import 'package:flutter/material.dart';
import 'package:traze/Google/Screens/home.dart';
import 'package:traze/beacon_broadcast_scan.dart';
import 'package:traze/thank_you_page.dart';
import 'package:traze/traze_about_covid.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/traze_appointment.dart';
import 'package:traze/traze_bluetooth.dart';
import 'package:traze/traze_broadcast.dart';
import 'package:traze/traze_heat_map.dart';
import 'package:traze/traze_login.dart';
import 'package:traze/traze_positive_scan.dart';
import 'package:traze/traze_screening.dart';
import 'package:traze/traze_status.dart';
import 'CovidAPI/homepage.dart';
import 'Persistence/database.dart';
import 'src/UI/custom_input_field.dart';
import 'package:traze/uuid_scan_2.dart';
import 'package:traze/beacon_broadcast_2.dart';

import 'package:traze/Persistence/database_cloud.dart';

class TestID extends StatelessWidget {
  TextEditingController _uuidController;

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        return true;
      } on Exception {
        return false;
      }
    }
  }

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
                    CustomInputField(
                        Icon(Icons.assignment, color: Colors.white),
                        'Enter your Test ID'),
                    Container(
                      width: 150,
                      child: RaisedButton(
                        //link to other page when pressed
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ThankYou()));
                          List<Map<String, dynamic>> queryRows =
                              await ProximityDatabaseProvider.instance
                                  .queryAll(1);
                          print('encounters table: \n');
                          print(queryRows);
                          queryRows = await ProximityDatabaseProvider.instance
                              .queryAll(2);
                          print('mypastuuids table: \n');
                          print(queryRows);
                          print('\n');
                          print('doing delete all..');
                          int rowsEffected = await ProximityDatabaseProvider
                              .instance
                              .deleteAll(1);
                          print('num rowsEffected (encounters): $rowsEffected');
                          rowsEffected = await ProximityDatabaseProvider
                              .instance
                              .deleteAll(2);
                          print(
                              'num rowsEffected (mypastuuids): $rowsEffected');
                          print('\n');
                          queryRows = await ProximityDatabaseProvider.instance
                              .queryAll(1);
                          print('encounters table: \n');
                          print(queryRows);
                          queryRows = await ProximityDatabaseProvider.instance
                              .queryAll(2);
                          print('mypastuuids table: \n');
                          print(queryRows);
                          print('\n');

                          //FirestoreDatabaseService.instance.addPositiveUuids(); // add uuids to positive uuid cloud database
                        },
                        color: Colors.orange,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          'Enter',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'By clicking Submit you agree that the information displayed above is correct to the best of your knowledge ',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Test ID'),
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
            CustomListTile(Icons.account_circle, 'Profile', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            }),
            CustomListTile(Icons.person, 'About Covid', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => APIHome()));
            }),
            CustomListTile(Icons.wifi, 'Heatmap', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TrazeMap()));
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
