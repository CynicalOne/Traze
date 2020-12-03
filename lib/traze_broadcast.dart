import 'dart:async';
import 'package:flutter/material.dart';

import 'package:traze/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:traze/UUID/uuid.dart';
import 'package:traze/UUID/uuid_util.dart';

import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/traze_about_covid.dart';
import 'package:traze/traze_appointment.dart';
import 'package:traze/traze_bluetooth.dart';
import 'package:traze/traze_home.dart';
import 'package:traze/traze_input_test.dart';
import 'package:traze/traze_positive_scan.dart';


class Broadcast extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

//var uuid = Uuid();

class _BroadcastState extends State<Broadcast> {
  // Generate a v4 (random) id
  static var UUID = Uuid().v5(Uuid.NAMESPACE_URL, 'traze signal');
  static const MAJOR_ID = 1;
  static const MINOR_ID = 100;
  static const TRANSMISSION_POWER = -59;
  static const IDENTIFIER = 'traze signal';
  static const LAYOUT = BeaconBroadcast.ALTBEACON_LAYOUT;
  static const MANUFACTURER_ID = 0x0118;

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  BeaconStatus _isTransmissionSupported;
  bool _isAdvertising = false;
  StreamSubscription<bool> _isAdvertisingSubscription;

  @override
  void initState() {
    super.initState();
    beaconBroadcast
        .checkTransmissionSupported()
        .then((isTransmissionSupported) {
      setState(() {
        _isTransmissionSupported = isTransmissionSupported;
      });
    });

    _isAdvertisingSubscription =
        beaconBroadcast.getAdvertisingStateChange().listen((isAdvertising) {
      setState(() {
        _isAdvertising = isAdvertising;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Beacon Broadcast'),
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
                CustomListTile(Icons.clear, 'Scan Results', () {
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Is transmission supported?',
                    style: Theme.of(context).textTheme.headline5),
                Text('$_isTransmissionSupported',
                    style: Theme.of(context).textTheme.subtitle1),
                Container(height: 16.0),
                Text('Is beacon started?',
                    style: Theme.of(context).textTheme.headline5),
                Text('$_isAdvertising',
                    style: Theme.of(context).textTheme.subtitle1),
                Container(height: 16.0),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      beaconBroadcast
                          .setUUID(UUID)
                          .setMajorId(MAJOR_ID)
                          .setMinorId(MINOR_ID)
                          .setTransmissionPower(-59)
                          .setIdentifier(IDENTIFIER)
                          .setLayout(LAYOUT)
                          .setManufacturerId(MANUFACTURER_ID)
                          .start();
                    },
                    child: Text('START'),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      beaconBroadcast.stop();
                    },
                    child: Text('STOP'),
                  ),
                ),
                Text('Beacon Data',
                    style: Theme.of(context).textTheme.headline5),
                Text('UUID: $UUID'),
                Text('Major id: $MAJOR_ID'),
                Text('Minor id: $MINOR_ID'),
                Text('Tx Power: $TRANSMISSION_POWER'),
                Text('Identifier: $IDENTIFIER'),
                Text('Layout: $LAYOUT'),
                Text('Manufacturer Id: $MANUFACTURER_ID'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_isAdvertisingSubscription != null) {
      _isAdvertisingSubscription.cancel();
    }
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
