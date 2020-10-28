import 'package:flutter/material.dart';
import 'package:traze/traze_screening.dart';

import 'traze_home.dart';
import 'traze_login.dart';


import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:traze/Persistence/proximity.dart';
import 'package:traze/Persistence/database.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:developer';



void main() {

  debugPrint("testing the print method");


  runApp(MaterialApp(title: 'Login App', home: LogIn())); //MaterialApp

  //runApp(MaterialApp(title: 'Drawer App', home: Home(),

  //runApp(MaterialApp(title: 'self screening',home: SelfScreening(),));


  /*
  var mydbtest = ProximityId(
    id: 2,
    datetime: 103,
    proximityid: 'testing for prox id',
  );
   */

  //log('testing print');

  //log(ProximityDatabaseProvider.db.getAllProximityIds());

  //ProximityDatabaseProvider.db.addProximityId(mydbtest);

  //log(ProximityDatabaseProvider.db.getAllProximityIds());

  //log(ProximityDatabaseProvider.db.getProximityId(2));




  /*
  await getAllProximityIds();

  await addProximityId(mydbtest);

  await getAllProximityIds();

  // print(await
  */


}
