import 'package:flutter/material.dart';

class PositiveScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.red,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'You have been in contact with somebody who has tested positive for Covid 19. Push the button below to make an appointment to get tested.',
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


