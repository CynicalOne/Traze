class Symptoms {
  List<String> _symptoms;

  Symptoms.initializeSymptoms() {
    _symptoms = List<String>();
  }
  List<String> get getString => _symptoms;
}

class Symptom {
  String _title;

  Symptom(this._title);

  String get getTitle => _title;
}
