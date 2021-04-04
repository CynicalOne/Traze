import 'dart:async';
import 'dart:io' show Platform, sleep;

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'dart:math';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:traze/Google/Screens/home.dart';
import 'package:traze/Persistence/database_cloud.dart';
import 'package:traze/Persistence/database_comparison.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/traze_about_covid.dart';
import 'package:traze/traze_appointment.dart';
import 'package:traze/traze_heat_map.dart';
import 'package:traze/traze_input_test.dart';
import 'package:traze/traze_positive_scan.dart';
import 'package:traze/traze_status.dart';
import 'package:traze/uuid_scan_2.dart';

import 'CovidAPI/homepage.dart';
import 'beacon_broadcast_2.dart';
import 'package:traze/Persistence/database.dart';

import 'package:traze/uuid_scan_2.dart';
import 'package:traze/Persistence/database.dart';

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
  List<String> token = [];
  int _nrMessaggesReceived = 0;
  var isRunning = false;
  bool isStopped = false; //global
  List<String> UUID = [];
  //static var positive = false;

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

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  BeaconStatus _isTransmissionSupported;
  bool _isAdvertising = false;
  StreamSubscription<bool> _isAdvertisingSubscription;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");

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

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);
    BeaconsPlugin.listenToBeacons(beaconEventsController);

    new Timer.periodic(const Duration(seconds: 20), (_) async {
      print("Starting scan");
      BeaconsPlugin.startMonitoring;
      setState(() {
        isRunning = true;
      });
      print('before the regular timer');

      print('Stop Scannage');
      UUID.add(_beaconResult.toString());
      print('This is my list');
      print(UUID);
      const time2 = const Duration(seconds: 20);
      new Timer.periodic(
          time2, (Timer t) async => await BeaconsPlugin.stopMonitoring);
      // get uuids scanned list, iterate and add each uuid to encounters database
      int insertedId = 0;
      for (var name in UUID) {
        if (name != "Not Scanned Yet.") {
          insertedId = await ProximityDatabaseProvider.instance.insert(1, {
            ProximityDatabaseProvider.columnName: name,
          });
          print('inserted id: $insertedId');
        }
      }
      List<Map<String, dynamic>> queryRows =
          await ProximityDatabaseProvider.instance.queryAll(1);
      print('encounters table: \n');
      print(queryRows);
      print('\n');
      setState(() {
        isRunning = false;
      });
    });

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty) {
            setState(() {
              token = data.toString().split(",");
              String onlyUUIDs = token[1]
                  .toString()
                  .substring(12, token[1].toString().length - 1);
              _beaconResult = onlyUUIDs;
              _nrMessaggesReceived++;
            });
            print("token" + token[1]);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    const duration1 = const Duration(hours: 12);
    new Timer.periodic(duration1, (Timer t) async {
      await FirestoreDatabaseService.instance.deleteOldPositiveUuids();
    });

    const duration2 = const Duration(seconds: 2);
    new Timer.periodic(duration2, (Timer t) async {
      //positive = await DatabaseComparison.instance.foundMatch();
    });

    print('Starting UUID broadcast');
    const time3 = const Duration(seconds: 900); //15 min we change uuid
    new Timer.periodic(time3, (Timer t) async {
      var uuid = generateV4();
      await beaconBroadcast
          .setUUID(uuid)
          .setMajorId(majorId)
          .setMinorId(minorId)
          .setTransmissionPower(transmissionPower)
          //.setIdentifier(identifier)
          //.setLayout(layout)
          //.setManufacturerId(manufacturerId)
          .start();
      // add broadcasting uuid to local database of my past broadcasting ids
      int insertedId2 = await ProximityDatabaseProvider.instance.insert(2, {
        ProximityDatabaseProvider.columnName: uuid,
      });
      print('the inserted id is $insertedId2');
      List<Map<String, dynamic>> queryRows2 =
          await ProximityDatabaseProvider.instance.queryAll(2);
      print('my past broadcasting uuids table: \n');
      print(queryRows2);
      print('\n');
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
                    await BeaconsPlugin.startMonitoring;

                    setState(() {
                      isRunning = true;
                    });
                  },
                  child: Text('Start Contact Tracing',
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
