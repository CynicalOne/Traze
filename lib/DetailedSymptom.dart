import 'package:flutter/material.dart';
import 'package:traze/self_screening.dart';
/*
class DetailedSymptom extends StatefulWidget {
  Symptom selectedSymptom;
  DetailedSymptom(this.selectedSymptom);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailedSymptomState(selectedSymptom);
  }
}

class DetailedSymptomState extends State<DetailedSymptom> {
  Symptom selectedSymptom;

  DetailedSymptomState(this.selectedSymptom);

  _handleReadCheckbox(bool readStatus) {
    this.setState(() {
      selectedSymptom.setReadState = readStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedSymptom.getTitle),
        leading: MaterialButton(
          onPressed: () {
            Navigator.pop(context, selectedSymptom.getReadState);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(selectedSymptom.getSymptomContent,
                  style: TextStyle(fontSize: 20)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Read?',
                  style: TextStyle(fontSize: 20.0),
                ),
                Checkbox(
                    value: selectedSymptom.getReadState,
                    onChanged: _handleReadCheckbox)
              ],
            )
          ],
        ),
      ),
    );
  }
}
*/
