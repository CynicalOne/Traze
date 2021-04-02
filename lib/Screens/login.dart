import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:traze/Screens/auth_bloc.dart';
import 'package:traze/src/UI/background_circle.dart';
import 'package:traze/src/UI/custom_input_field.dart';
import 'package:traze/Screens/home.dart';
import 'package:traze/traze_heat_map.dart';

class GoogleLogin extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<GoogleLogin> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey,
      child: Stack(
        children: <Widget>[
          BackgroundCircle(0.0, 0.3),
          BackgroundCircle(1.0, 0.5),
          BackgroundCircle(0.1, 0.7),
          Center(
            child: Container(
              width: 500,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 10.0,
                    color: Colors.orange,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomInputField(
                        Icon(Icons.person, color: Colors.white), 'Username'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomInputField(
                        Icon(Icons.lock, color: Colors.white), 'Password'),
                  ),
                  Container(
                    width: 250,
                    child: RaisedButton(
                      //link to other page when pressed
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HeatMap()));
                      },
                      color: Colors.orange,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Or ',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  SignInButton(
                    Buttons.Google,
                    text: 'Login with Google',
                    onPressed: () => authBloc.loginGoogle(),
                  ),
                  SizedBox(height: 25.0),
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.orangeAccent)),
                        // can add more TextSpans here...
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
