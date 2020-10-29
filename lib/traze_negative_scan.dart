import 'package:flutter/material.dart';

class NegativeScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.green,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'You have not been in contact with anyone who has tested positive for Covid 19.',
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.arrow_right),
            color: Colors.white,
            iconSize: 50.0,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
