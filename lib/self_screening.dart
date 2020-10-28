class Symptoms {
  List<Symptom> _symptoms;

  Symptoms.initializeSymptoms() {
    _symptoms = List<Symptom>();

    _symptoms.add(Symptom(('Fever or chills')));
  }
  List<Symptom> get getSymptoms => _symptoms;
}

class Symptom {
  String _title;

  Symptom(this._title);

  String get getTitle => _title;
}
