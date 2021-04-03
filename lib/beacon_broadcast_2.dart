import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:traze/Persistence/database.dart';
import 'package:traze/Persistence/database_comparison.dart';
import 'package:traze/quiz_pages/landing_page.dart';

import 'dart:math';

import 'package:traze/traze_about_covid.dart';
import 'package:traze/traze_appointment.dart';
import 'package:traze/traze_heat_map.dart';
import 'package:traze/traze_input_test.dart';
import 'package:traze/traze_positive_scan.dart';

import 'beacon_broadcast_scan.dart';

class BroadcastTwo extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<BroadcastTwo> {
  final Random _random = Random();
  static const majorId = 0;
  static const minorId = 30;
  static const transmissionPower = -59;
  static const identifier = 'com.example.myDeviceRegion';
  //static const AdvertiseMode advertiseMode = AdvertiseMode.lowPower;
  static const layout = BeaconBroadcast.ALTBEACON_LAYOUT;
  static const manufacturerId = 0x0118;
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    String uuid = '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';

    return uuid;
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');

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

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  BeaconStatus _isTransmissionSupported;
  bool _isAdvertising = false;
  StreamSubscription<bool> _isAdvertisingSubscription;

  Future<void> initPlatformState() async {
    const time = const Duration(seconds: 30); //.scan every 5 min

    new Timer.periodic(time, (Timer t) async => generateV4());

    print('Starting broadcast');

    const time3 = const Duration(seconds: 2);
    const time4 = const Duration(seconds: 15); //15 min we change uuid 900 secs
    new Timer.periodic(
        time3,
        (Timer t) async => await beaconBroadcast
            .setUUID(generateV4())
            .setMajorId(majorId)
            .setMinorId(minorId)
            .setTransmissionPower(transmissionPower)
            //.setIdentifier(identifier)
            //.setLayout(layout)
            //.setManufacturerId(manufacturerId)
            .start());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contact Tracing'),
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
              CustomListTile(Icons.person, 'About Covid', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutCovid()));
              }),
              CustomListTile(Icons.account_circle, 'Make an Appointment', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Appointment()));
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
                Container(height: 16.0),
                Text('Is beacon broadcasting?',
                    style: Theme.of(context).textTheme.headline5),
                Text('$_isAdvertising',
                    style: Theme.of(context).textTheme.subtitle1),
                Container(height: 16.0),
                Text('UUID Being Broadcasted:',
                    style: Theme.of(context).textTheme.headline5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('UUID:' + generateV4()),
                ),
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
