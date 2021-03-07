import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';

//for testing, will delete packages
import 'package:traze/Persistence/database.dart';
import 'package:traze/Persistence/database_cloud.dart';

class BroadcastTwo extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<BroadcastTwo> {
  static const String uuid = '39ED98FF-2900-441A-802F-9C398FC199D2';
  static const int majorId = 1;
  static const int minorId = 100;
  static const int transmissionPower = -59;
  static const String identifier = 'com.example.myDeviceRegion';
  static const AdvertiseMode advertiseMode = AdvertiseMode.lowPower;
  static const String layout = BeaconBroadcast.ALTBEACON_LAYOUT;
  static const int manufacturerId = 0x0118;
  static const List<int> extraData = [100];

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
                          .setUUID(uuid)
                          .setMajorId(majorId)
                          .setMinorId(minorId)
                          .setTransmissionPower(transmissionPower)
                          .setAdvertiseMode(advertiseMode)
                          .setIdentifier(identifier)
                          .setLayout(layout)
                          .setManufacturerId(manufacturerId)
                          .setExtraData(extraData)
                          .start();
                    },
                    child: Text('START'),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () async {
                      // for testing databases, will delete

                      // sqlite
                      /*
                      int insertedId = await ProximityDatabaseProvider.instance.insert(1, {
                        ProximityDatabaseProvider.columnName: 'meep',
                      });
                      print('the inserted id (encounters) is $insertedId');
                       */

                      /*
                      List<Map<String, dynamic>> queryRows = await ProximityDatabaseProvider.instance.queryAll(1);
                      print('encounters table: \n');
                      print(queryRows);
                      print('\n');

                      int rowsEffected1 = await ProximityDatabaseProvider.instance.delete(1, 1);
                      print('the number of rows effected by deleting id 5 (encounters): $rowsEffected1');
                      queryRows = await ProximityDatabaseProvider.instance.queryAll(1);
                      print(queryRows);

                       */

                      /*
                      int insertedId2 = await ProximityDatabaseProvider.instance.insert(2, {
                        ProximityDatabaseProvider.columnName: 'cash money',
                      });
                      print('the inserted id (past uuids) is $insertedId2');
                       */
                      /*
                      List<Map<String, dynamic>> queryRows2 = await ProximityDatabaseProvider.instance.queryAll(2);
                      print(queryRows2);
                      int rowsEffected = await ProximityDatabaseProvider.instance.delete(2, 20);
                      print('the number of rows effected by deleting id 2 (past uuids): $rowsEffected');
                      queryRows = await ProximityDatabaseProvider.instance.queryAll(2);
                      print(queryRows);

                      int nrowsEffected = await ProximityDatabaseProvider.instance.update(1,{
                        ProximityDatabaseProvider.columnId: 1,
                        ProximityDatabaseProvider.columnName: 'wap',
                      });
                      print('number of rows affected by updating id 1 (encounters) is $nrowsEffected');
                      */

                      /*
                      List<Map<String, dynamic>> queryRows = await ProximityDatabaseProvider.instance.queryAll(1);
                      print('\n');
                      print('encounters: ');
                      print(queryRows);
                      print('\n');
                      queryRows = await ProximityDatabaseProvider.instance.queryAll(2);
                      print('past uuids: ');
                      print(queryRows);
                      print('\n');
                       */

                      /*
                      List<Map<String, dynamic>> recentUuids_id = await ProximityDatabaseProvider.instance.queryMyRecentUuids_id();
                      print('these are my recent uuids : _id');
                      print(recentUuids_id);
                      List<Map<String, dynamic>> recentUuids_uuid = await ProximityDatabaseProvider.instance.queryMyRecentUuids_uuid();
                      print('these are my recent uuids :uuid');
                      print(recentUuids_uuid);
                       */

                      /*
                      List<String> recentUuids_uuid = await ProximityDatabaseProvider.instance.queryMyRecentUuids();
                      print('these are my recent uuids:');
                      print(recentUuids_uuid);
                       */

                      // firestore
                      //FirestoreDatabaseService.instance.addRecord(0, 'yeeeeehaw');
                      //FirestoreDatabaseService.instance.addPositiveUuids();
                      //FirestoreDatabaseService.instance.testingFirestoreQuery();

                      // end of testing

                      beaconBroadcast.stop();
                    },
                    child: Text('STOP'),
                  ),
                ),
                Text('Beacon Data',
                    style: Theme.of(context).textTheme.headline5),
                Text('UUID: $uuid'),
                Text('Major id: $majorId'),
                Text('Minor id: $minorId'),
                Text('Tx Power: $transmissionPower'),
                Text('Advertise Mode Value: $advertiseMode'),
                Text('Identifier: $identifier'),
                Text('Layout: $layout'),
                Text('Manufacturer Id: $manufacturerId'),
                Text('Extra data: $extraData'),
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
