import 'package:traze/src/model/generic_failure.dart';
import 'package:traze/src/model/qualified_characteristic.dart';
import 'package:traze/src/model/result.dart';
import 'package:meta/meta.dart';

@immutable
class WriteCharacteristicInfo {
  final QualifiedCharacteristic characteristic;
  final Result<void, GenericFailure<WriteCharacteristicFailure>> result;

  const WriteCharacteristicInfo({
    @required this.characteristic,
    @required this.result,
  });
}

enum WriteCharacteristicFailure { unknown }
