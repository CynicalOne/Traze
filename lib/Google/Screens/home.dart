import 'package:traze/CovidAPI/homepage.dart';
import 'package:traze/Google/Blocs/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traze/quiz_pages/landing_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../beacon_broadcast_2.dart';
import '../../beacon_broadcast_scan.dart';

import '../../traze_input_test.dart';
import '../../traze_status.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Profile',
        ),
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
            CustomListTile(Icons.account_circle, 'Profile', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            }),
            CustomListTile(Icons.person, 'About Covid', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => APIHome()));
            }),
            CustomListTile(Icons.check, 'Self Screening', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LandingPage()));
            }),
            CustomListTile(Icons.bluetooth, 'Scan for Devices', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BeaconScan()));
            }),
            CustomListTile(Icons.clear, 'Scan Status', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactStatus()));
            }),
            CustomListTile(Icons.assignment_ind_outlined, 'Your Test ID', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TestID()));
            }),
            CustomListTile(Icons.arrow_forward_ios, 'Sign Out', () {
              _signOut().whenComplete(() {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => FirebaseAuthDemo()));
              });
            }),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: 400,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'images/Transparent_Waze.png',
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'If you have experienced any symptoms and have taken our self screening quiz, or have come into contact with someone who has tested positive for covid, please make an appointment at the link below.',
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 250,
                      child: RaisedButton(
                        //link to appointment url when pressed
                        onPressed: _launchURL,
                        color: Colors.orange,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          'Schedule Test Appointment',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: RaisedButton(
                        //link to appointment url when pressed
                        onPressed: _launchURL2,
                        color: Colors.orange,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          'Schedule Vaccine Appointment',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _signOut() async {
    await _auth.signOut();
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

_launchURL() async {
  const url =
      'https://www.hhs.gov/coronavirus/community-based-testing-sites/index.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL2() async {
  const url = 'https://myturn.ca.gov';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
