import 'package:flutter/material.dart';
import './landing_page.dart';

class ScorePage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ScorePage(this.score, this.totalQuestions);

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.orangeAccent,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'Your Diagnostic: ',
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 50.0,
            ),
          ),
          score >= 4
              ? Text(
                  'You have enough syptoms to say you may have Covid-19, please make an appointmemnt to get tested',
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                  textAlign: TextAlign.center,
                )
              : Text(
                  'You dont have enough symptoms to say you have covid',
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
          new IconButton(
            icon: new Icon(Icons.arrow_right),
            color: Colors.white,
            iconSize: 50.0,
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new LandingPage()),
                (Route route) => route == null),
          )
        ],
      ),
    );
  }
}
