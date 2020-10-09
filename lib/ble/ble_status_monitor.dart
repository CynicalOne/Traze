import 'package:traze/flutter_reactive_ble.dart';
import 'package:traze/ble/reactive_state.dart';

class BleStatusMonitor implements ReactiveState<BleStatus> {
  const BleStatusMonitor(this._ble);

  final FlutterReactiveBle _ble;

  @override
  Stream<BleStatus> get state => _ble.statusStream;
}
