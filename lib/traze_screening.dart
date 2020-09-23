import 'dart:io';

import 'package:flutter/material.dart';
import 'package:traze/DetailedSymptom.dart';
import 'package:traze/self_screening.dart';

class SelfScreening extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SelfScreeningState();
  }
}

class SelfScreeningState extends State<SelfScreening> {
  List<Symptom> _symptoms;

  SelfScreeningState() {
    _symptoms = Symptoms.initializeSymptoms().getSymptoms;
  }
  _handleDetailedViewData(int index) async {
    bool data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailedSymptom(_symptoms[index])));

    this.setState(() {
      _symptoms[index].setReadState = data;
    });
  }

  _handleIconDisplay(int index) {
    bool readStatus = _symptoms[index].getReadState;
    return Icon(
      (readStatus ? Icons.check_circle : Icons.remove_circle),
      color: (readStatus) ? Colors.green : Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
          itemCount: _symptoms.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0))),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_symptoms[index].getTitle),
                    _handleIconDisplay(index)
                  ],
                ),
                onTap: () {
                  _handleDetailedViewData(index);
                },
              ),
            );
          }),
    );
  }
}
