import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:traze/src/ble/reactive_state.dart';
import 'package:meta/meta.dart';

import 'package:traze/Persistence/proximity.dart';
import 'package:traze/Persistence/database.dart';

import '../../Persistence/database.dart';
import '../../Persistence/database.dart';
import '../../traze_positive_scan.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner(this._ble);

  final FlutterReactiveBle _ble;
  final StreamController<BleScannerState> _stateStreamController =
      StreamController();

  final _devices = <DiscoveredDevice>[];
  final _ourUUID = <String>[];

  ProximityDatabaseProvider pdp;

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  BuildContext get context => null;

  void startScan(List<Uuid> serviceIds) {
    _devices.clear();
    _subscription?.cancel();
    _subscription =
        _ble.scanForDevices(withServices: serviceIds).listen((device) {
      final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
      if (knownDeviceIndex >= 0) {
        _devices[knownDeviceIndex] = device;
      } else {
        _devices.add(device);
        _ourUUID.add(device.id);
        print('uuid list');
        print(_ourUUID);
        // adding _ourUUID into the local database
        /*for (var i = 0; i < _ourUUID.length; i++) {
          pdp.addProximityId(
              new ProximityId(id: 0, datetime: 0, proximityid: _ourUUID[i]));
        }

        pdp.foundMatch() == true
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => PositiveScan()))
            : Text(
                'dont navigate',
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
                textAlign: TextAlign.center,
              );*/
      }
      _pushState();
    });
    _pushState();
  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  StreamSubscription _subscription;
}

@immutable
class BleScannerState {
  const BleScannerState({
    @required this.discoveredDevices,
    @required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}
