import 'package:flutter/material.dart';

class AnswerButton extends StatefulWidget {
  final bool _answer;
  final VoidCallback _onTap;

  AnswerButton(this._answer, this._onTap);

  @override
  State createState() => new AnswerButtonState();
}

class AnswerButtonState extends State<AnswerButton> {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      // true button
      child: new Material(
        color: widget._answer == true ? Colors.greenAccent : Colors.redAccent,
        child: new InkWell(
          onTap: () => widget._onTap(),
          child: new Center(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
              padding: new EdgeInsets.all(20.0),
              child: new Text(
                widget._answer == true ? 'YES' : 'NO',
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
