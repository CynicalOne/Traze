import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  Icon fieldIcon;
  String hintText;

  CustomInputField(this.fieldIcon, this.hintText);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 250,
      child: Material(
          elevation: 5,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.orangeAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: fieldIcon,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                width: 200,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: hintText,
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
