import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:traze/src/ble/ble_device_connector.dart';
import 'package:provider/provider.dart';
import 'package:traze/src/model/uuid.dart';

class DeviceDetailScreen extends StatelessWidget {
  final DiscoveredDevice device;

  const DeviceDetailScreen({@required this.device}) : assert(device != null);

  @override
  Widget build(BuildContext context) =>
      Consumer2<BleDeviceConnector, ConnectionStateUpdate>(
        builder: (_, deviceConnector, connectionStateUpdate, __) =>
            _DeviceDetail(
          device: device,
          connectionUpdate: connectionStateUpdate != null &&
                  connectionStateUpdate.deviceId == device.id
              ? connectionStateUpdate
              : ConnectionStateUpdate(
                  deviceId: device.id,
                  connectionState: DeviceConnectionState.disconnected,
                  failure: null,
                ),
          connect: deviceConnector.connect,
          disconnect: deviceConnector.disconnect,
          discoverServices: deviceConnector.discoverServices,
        ),
      );
}

class _DeviceDetail extends StatelessWidget {
  const _DeviceDetail({
    @required this.device,
    @required this.connectionUpdate,
    @required this.connect,
    @required this.disconnect,
    @required this.discoverServices,
    Key key,
  })  : assert(device != null),
        assert(connectionUpdate != null),
        assert(connect != null),
        assert(disconnect != null),
        assert(discoverServices != null),
        super(key: key);

  final DiscoveredDevice device;
  final ConnectionStateUpdate connectionUpdate;
  final void Function(String deviceId) connect;
  final void Function(String deviceId) disconnect;
  final void Function(String deviceId) discoverServices;

  bool _deviceConnected() =>
      connectionUpdate.connectionState == DeviceConnectionState.connected;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          disconnect(device.id);

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(device.name ?? "unknown"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "ID: ${connectionUpdate.deviceId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Status: ${connectionUpdate.connectionState}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Do something
                          connect(device.id);
                          //discoverServices(device.id);
                          print("what i print is bellow");
                          print(device.id);
                          print(device.serviceData.values.toString().isEmpty);
                          //var _list = device.serviceData.values.toList();
                          //var _list2 = device.serviceData.entries.toList();
                          var _list3 = DiscoveredService$.characteristicIds;
                          var _list4 = DiscoveredService$.serviceId.get;
                          //  .toString();

                          print(_list4);

                          print("what i print is above");
                        },
                        //onPressed: !_deviceConnected()
                        //  ? () => connect(device.id);
                        //print(device.serviceData.toString())
                        //: null,
                        child: const Text("Connect"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _deviceConnected()
                            ? () => disconnect(device.id)
                            : null,
                        child: const Text("Disconnect"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: RaisedButton(
                        onPressed: _deviceConnected()
                            ? () => discoverServices(device.id)
                            : null,
                        child: const Text("Services"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
