import 'package:flutter/material.dart';

import 'package:traze/traze_positive_scan.dart';
import 'package:traze/traze_screening.dart';

import 'traze_login.dart';


import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(title: 'Login App', home: LogIn())); //MaterialApp

  //runApp(MaterialApp(title: 'Drawer App', home: Home(),

  //runApp(MaterialApp(title: 'self screening',home: SelfScreening(),));
}
