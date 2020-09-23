class Symptoms {
  List<Symptom> _symptoms;

  Symptoms.initializeSymptoms() {
    _symptoms = List<Symptom>();

    _symptoms.add(Symptom(
        ('Fever or chills'),
        'A fever is a temporary increase in your body temperature but, usually is not a cause for concern unless it reaches 103 F (39.4 C) or higher.',
        false));
    _symptoms.add(Symptom(
        ('Cough'),
        'An occasional cough is normal — it helps clear irritants and secretions from your lungs and prevents infection. However, a cough that persists for weeks is usually the result of a medical problem.',
        false));
    _symptoms.add(Symptom(
        ('Shortness of breath or difficulty breathing'),
        'known medically as dyspnea — is often described as an intense tightening in the chest, air hunger, difficulty breathing, breathlessness or a feeling of suffocation. Very strenuous exercise, extreme temperatures, obesity and higher altitude all can cause shortness of breath in a healthy person.',
        false));
    _symptoms.add(Symptom(
        ('Fatigue'),
        'Fatigue is a term used to describe an overall feeling of tiredness or lack of energy. It isn’t the same as simply feeling drowsy or sleepy. When you’re fatigued, you have no motivation and no energy. Being sleepy may be a symptom of fatigue, but it’s not the same thing.',
        false));
    _symptoms.add(Symptom(
        ('Muscle or body aches'),
        'Aches can also be caused by your everyday life, especially if you stand, walk, or exercise for long periods of time.',
        false));
    _symptoms.add(Symptom(
        ('Headache'),
        'Normal headaches are usually caused by dehydration, muscle tension, nerve pain, fever, caffeine withdrawal, drinking alcohol, or eating certain foods. They may also happen as a result of toothache, hormonal changes, or pregnancy or as a side effect of medication.',
        false));
    _symptoms.add(Symptom(
        ('Loss of taste or smell'),
        'A reduced ability to taste sweet, sour, bitter, salty, and umami',
        false));
    _symptoms.add(Symptom(
        ('Sore throat'),
        'A sore throat is pain, scratchiness or irritation of the throat that often worsens when you swallow.',
        false));
    _symptoms.add(Symptom(
        ('Congestion or runny nose'),
        'Nasal congestion can be caused by anything that irritates or inflames the nasal tissues. Infections — such as colds, flu or sinusitis — and allergies are frequent causes of nasal congestion and runny nose. Sometimes a congested and runny nose can be caused by irritants such as tobacco smoke and car exhaust.',
        false));
    _symptoms.add(Symptom(
        ('Nausea or vomiting'),
        'Nausea is the sensation of an urge to vomit. Vommiting also known as puking, throwing up, barfing, emesis, among other names) is the involuntary, forceful expulsion of the contents of ones stomach through the mouth and sometimes the nose.  ',
        false));
    _symptoms.add(Symptom(
        ('Diarrhea'),
        'is the condition of having at least three loose, liquid, or watery bowel movements each day.',
        false));
  }
  List<Symptom> get getSymptoms => _symptoms;
}

class Symptom {
  String _title;
  String _symptomContent;
  bool _symptomRead;

  Symptom(this._title, this._symptomContent, this._symptomRead);

  String get getTitle => _title;
  String get getSymptomContent => _symptomContent;
  bool get getReadState => _symptomRead;
  set setReadState(bool readState) => this._symptomRead = readState;
}
