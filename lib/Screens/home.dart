import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:traze/Screens/auth_bloc.dart';
import 'package:traze/Screens/login.dart';
import 'package:traze/quiz_pages/landing_page.dart';

import '../beacon_broadcast_2.dart';
import '../beacon_broadcast_scan.dart';
import '../traze_about_covid.dart';
import '../traze_appointment.dart';
import '../traze_heat_map.dart';
import '../traze_input_test.dart';
import '../traze_status.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GoogleLogin(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      body: Container(
        child: StreamBuilder<User>(
            stream: authBloc.currentUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data.photoURL.replaceFirst('s96', 's400')),
                        radius: 20.0,
                      ),
                      Text(
                        snapshot.data.displayName,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              );
            }),
      ),
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                  Colors.deepOrangeAccent,
                  Colors.orangeAccent,
                ])),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        elevation: 10.0,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/Transparent_Waze.png',
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Traze',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      )
                    ],
                  ),
                )),
            CustomListTile(Icons.person, 'About Covid', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutCovid()));
            }),
            CustomListTile(Icons.account_circle, 'Make an Appointment', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Appointment()));
            }),
            CustomListTile(Icons.wifi, 'Heatmap', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HeatMap()));
            }),
            CustomListTile(Icons.check, 'Self Screening', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LandingPage()));
            }),
            CustomListTile(Icons.bluetooth, 'Scan for Devices', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BeaconScan()));
            }),
            CustomListTile(Icons.airplay_rounded, 'Broadcast', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BroadcastTwo()));
            }),
            CustomListTile(Icons.clear, 'Positive Scan Message', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactStatus()));
            }),
            CustomListTile(Icons.assignment_ind_outlined, 'Your Test ID', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TestID()));
            }),
            CustomListTile(Icons.person, 'Sign out', () => authBloc.logout()),
          ],
        ),
      ),
    );
  }
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
