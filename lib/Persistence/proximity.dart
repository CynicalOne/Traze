import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class ProximityId {
  int id;
  int datetime;
  String proximityid;

  ProximityId({this.id, this.datetime, this.proximityid});

  factory ProximityId.fromMap(Map<String, dynamic> json) => new ProximityId(
    id: json["id"],
    datetime: json["datetime"],
    proximityid: json["id"],
  );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "datetime": datetime,
        "proximityid": proximityid,
      };
}
