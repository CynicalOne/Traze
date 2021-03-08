import 'dart:async';
import 'dart:io' show Platform, sleep;

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/traze_about_covid.dart';
import 'package:traze/traze_appointment.dart';
import 'package:traze/traze_home.dart';
import 'package:traze/traze_input_test.dart';
import 'package:traze/traze_positive_scan.dart';

import 'beacon_broadcast_2.dart';

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

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    beaconEventsController.close();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    await BeaconsPlugin.addRegion(
        "BeaconType1", "909c3cf9-fc5c-4841-b695-380958a51a5a");
    await BeaconsPlugin.addRegion(
        "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");

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

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring;
          setState(() {
            isRunning = true;
          });
        }
      });
    } else if (Platform.isIOS) {
      await BeaconsPlugin.startMonitoring;
      setState(() {
        isRunning = true;
      });
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                    if (Platform.isAndroid) {
                      await BeaconsPlugin.stopMonitoring;

                      setState(() {
                        isRunning = false;
                      });
                    }
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
                    Duration start = const Duration(seconds: 2);
                    setState(() {
                      isRunning = true;
                    });

                    await BeaconsPlugin.startMonitoring;

                    print('before ten seconds');
                    sleep(new Duration(seconds: 5));
                    print(
                        _beaconResult); // This will be printed 10 seconds later.

                    BeaconsPlugin.stopMonitoring;
                    setState(() {
                      isRunning = false;
                    });

                    //here the uuid should be saved wherever we want
                  },
                  child: Text('Commence Contact Tracing',
                      style: TextStyle(fontSize: 20)),
                ),
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
