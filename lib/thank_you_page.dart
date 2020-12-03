import 'dart:async';

import 'package:flutter/material.dart';
import 'package:traze/traze_home.dart';

class ThankYou extends StatefulWidget {
  @override
  _GreetingState createState() => new _GreetingState();
}

class _GreetingState extends State<ThankYou> {
  @override
  initState() {
    super.initState();
    new Timer(const Duration(seconds: 2), onClose);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.redAccent,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'Thank You For Submitting,Stay Safe,Wear A Mask',
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 45.0,
            ),
          ),
        ],
      ),
    );
  }

  void onClose() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new Home(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        }));
  }
}
