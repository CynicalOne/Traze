import 'dart:async';

import 'package:traze/Persistence/database.dart';
import 'package:traze/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:traze/UUID/uuid.dart';
import 'package:traze/UUID/uuid_util.dart';

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
                    onPressed: () async{
                      int insertedId = await ProximityDatabaseProvider.instance.insert(1, {
                        ProximityDatabaseProvider.columnName: 'leedle leedle leedle lee',
                      });
                      print('the inserted id (encounters) is $insertedId');
                      List<Map<String, dynamic>> queryRows = await ProximityDatabaseProvider.instance.queryAll(1);
                      print(queryRows);
                      int rowsEffected1 = await ProximityDatabaseProvider.instance.delete(1, 5);
                      print('the number of rows effected (encounters): $rowsEffected1');
                      queryRows = await ProximityDatabaseProvider.instance.queryAll(1);
                      print(queryRows);

                      int insertedId2 = await ProximityDatabaseProvider.instance.insert(2, {
                        ProximityDatabaseProvider.columnName: 'ratthew',
                      });
                      print('the inserted id (past uuids) is $insertedId2');
                      int insertedId3 = await ProximityDatabaseProvider.instance.insert(2, {
                        ProximityDatabaseProvider.columnName: 'ludacris cross apple sauce',
                      });
                      print('the inserted id (past uuids) is $insertedId3');
                      List<Map<String, dynamic>> queryRows2 = await ProximityDatabaseProvider.instance.queryAll(2);
                      print(queryRows2);
                      int rowsEffected = await ProximityDatabaseProvider.instance.delete(2, 2);
                      print('the number of rows effected (past uuids): $rowsEffected');
                      queryRows = await ProximityDatabaseProvider.instance.queryAll(2);
                      print(queryRows);

                      int nrowsEffected = await ProximityDatabaseProvider.instance.update(1,{
                        ProximityDatabaseProvider.columnId: 1,
                        ProximityDatabaseProvider.columnName: 'wap',
                      });
                      print('number of rows affected by updated $nrowsEffected');
                      queryRows = await ProximityDatabaseProvider.instance.queryAll(1);
                      print(queryRows);
                      queryRows = await ProximityDatabaseProvider.instance.queryAll(2);
                      print(queryRows);


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
