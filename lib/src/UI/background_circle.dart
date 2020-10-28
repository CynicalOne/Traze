import 'package:flutter/material.dart';

class BackgroundCircle extends StatelessWidget {
  double width;
  double height;
  String align;

  BackgroundCircle(
    this.width,
    this.height,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.bottomCenter,
      widthFactor: width,
      heightFactor: height,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(200)),
        color: Color.fromRGBO(255, 255, 0, 0.4),
        child: Container(
          width: 400,
          height: 400,
        ),
      ),
    );
  }
}
