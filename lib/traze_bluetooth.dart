import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:traze/src/ble/ble_device_connector.dart';
import 'package:traze/src/ble/ble_scanner.dart';
import 'package:traze/src/ble/ble_status_monitor.dart';
import 'package:traze/src/ui/ble_status_screen.dart';
import 'package:traze/src/ui/device_list.dart';
import 'package:provider/provider.dart';

const _themeColor = Colors.lightGreen;

final _ble = FlutterReactiveBle();
final _scanner = BleScanner(_ble);
final _monitor = BleStatusMonitor(_ble);
final _connector = BleDeviceConnector(_ble);

class Bluetooth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BluetoothState();
  }
}

class BluetoothState extends State<Bluetooth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan For Devices'),
        leading: MaterialButton(
          onPressed: () {
            Navigator.pop(context, _ble);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: MultiProvider(
        providers: [
          Provider.value(value: _scanner),
          Provider.value(value: _monitor),
          Provider.value(value: _connector),
          StreamProvider<BleScannerState>(
            create: (_) => _scanner.state,
            initialData: const BleScannerState(
              discoveredDevices: [],
              scanIsInProgress: false,
            ),
          ),
          StreamProvider<BleStatus>(
            create: (_) => _monitor.state,
            initialData: BleStatus.unknown,
          ),
          StreamProvider<ConnectionStateUpdate>(
            create: (_) => _connector.state,
            initialData: const ConnectionStateUpdate(
              deviceId: 'Unknown device',
              connectionState: DeviceConnectionState.disconnected,
              failure: null,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Reactive BLE example',
          color: _themeColor,
          theme: ThemeData(primarySwatch: _themeColor),
          home: HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<BleStatus>(
        builder: (_, status, __) {
          if (status == BleStatus.ready) {
            return DeviceListScreen();
          } else {
            return BleStatusScreen(status: status);
          }
        },
      );
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
