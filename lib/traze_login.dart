import 'package:flutter/material.dart';
import 'package:traze/traze_heat_map.dart';

import 'src/UI/custom_input_field.dart';
import 'src/UI/background_circle.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.deepOrangeAccent,
        child: Stack(
          children: <Widget>[
            BackgroundCircle(0.0, 0.3),
            BackgroundCircle(1.0, 0.5),
            BackgroundCircle(0.1, 0.7),
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
                      CustomInputField(
                          Icon(Icons.person, color: Colors.white), 'Username'),
                      CustomInputField(
                          Icon(Icons.lock, color: Colors.white), 'Password'),
                      Container(
                        width: 150,
                        child: RaisedButton(
                          //link to other page when pressed
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrazeMap()));
                          },
                          color: Colors.orange,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: 160,
                        child: RaisedButton(
                          //link to other page when pressed
                          onPressed: () {},
                          color: Colors.white12,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Text('Create Account',
                              style: TextStyle(fontSize: 18)),
                        ),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
