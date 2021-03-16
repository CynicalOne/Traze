import 'dart:async';
import 'dart:io' show Platform, sleep;

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:traze/Persistence/database_cloud.dart';
import 'package:traze/Persistence/database_comparison.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/traze_about_covid.dart';
import 'package:traze/traze_appointment.dart';
import 'package:traze/traze_home.dart';
import 'package:traze/traze_input_test.dart';
import 'package:traze/traze_positive_scan.dart';

import 'beacon_broadcast_2.dart';

import 'package:traze/uuid_scan_2.dart';
import 'package:traze/Persistence/database.dart';

FindDevicesScreen d = new FindDevicesScreen(); // for uuid names list


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BeaconScan());
}

class BeaconScan extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<BeaconScan> {
  String _beaconResult = 'Not Scanned Yet.';
  int _nrMessaggesReceived = 0;
  var isRunning = false;
  bool isStopped = false; //global

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");
    }
    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    const time = const Duration(seconds: 10);
    new Timer.periodic(
        time, (Timer t) async => await BeaconsPlugin.startMonitoring);
    setState(() {
      isRunning = true;
    });

    print('Stop Scannage');
    const time2 = const Duration(seconds: 20);
    new Timer.periodic(
        time2, (Timer t) async => await BeaconsPlugin.stopMonitoring);
    // get names list, iterate and add each uuid to encounters database
    int insertedId = 0;
    for (var name in d.names) {
      insertedId = await ProximityDatabaseProvider.instance.insert(1,
          {
            ProximityDatabaseProvider.columnName: name,
          });
      print('inserted id: $insertedId');
    }
    List<Map<String, dynamic>> queryRows = await ProximityDatabaseProvider.instance.queryAll(1);
    print('encounters table: \n');
    print(queryRows);
    print('\n');
    setState(() {
      isRunning = false;
    });

    print(_beaconResult);

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty) {
            setState(() {
              _beaconResult = data;
              _nrMessaggesReceived++;
            });
            print("Beacons DataReceived: " + data);
            print(data);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    // checks for old uuids and deletes old uuids from the positive uuid database
    const duration1 = Duration(hours:12);
    new Timer.periodic(
        duration1, (Timer t) async => await FirestoreDatabaseService.instance.deleteOldPositiveUuids());

    // compares encounters database with positive uuid database for matching uuids
    const duration2 = Duration(hours:12);
    bool positive = false;
    new Timer.periodic(
      duration2, (Timer t) async {
      positive = await DatabaseComparison.instance.foundMatch();
    });

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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$_beaconResult'),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Text('$_nrMessaggesReceived'),
              SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: isRunning,
                child: RaisedButton(
                  onPressed: () async {
                    BeaconsPlugin.stopMonitoring;

                    setState(() {
                      isRunning = false;
                    });
                  },
                  child: Text('Stop Scanning', style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: !isRunning,
                child: RaisedButton(
                  onPressed: () async {
                    initPlatformState();
                    setState(() {
                      isRunning = false;
                    });
                    BeaconsPlugin.stopMonitoring;
                  },
                  child: Text('Stop Contact Tracing',
                      style: TextStyle(fontSize: 20)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    beaconEventsController.close();
    super.dispose();
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
