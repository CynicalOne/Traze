import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:convert/convert.dart';

void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<String> getData() async {
    var responce = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          //"key": "n.,nkjenckjn"
          "Accept": "application/json"
        });

    //print(responce.body);

    List data = json.decode(responce.body);

    print(data[1]["title"]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: new Center(
          child: new RaisedButton(
            child: new Text('Get Data'),
            onPressed: getData,
          ),
        ),
      ),
    );
  }
}
