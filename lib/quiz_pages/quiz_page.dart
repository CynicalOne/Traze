import 'package:flutter/material.dart';
import '../utils/questions.dart';
import '../utils/quiz.dart';

import 'package:traze/src/UI/answer_button.dart';
import 'package:traze/src/UI/question_text.dart';

import 'package:traze/quiz_pages/score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question('Fever or chills', true),
    new Question('Cough', true),
    new Question('Shortness of breath or difficulty breathing', true),
    new Question('Fatigue', true),
    new Question('Muscle or body aches', true),
    new Question('Headache', true),
    new Question('Loss of taste or smell', true),
    new Question('Nausea or vomiting', true),
    new Question('Diarrhea', true),
  ]);

  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    quiz.length == questionNumber
        ? Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new ScorePage(quiz.score, quiz.length)),
            (Route route) => route == null)
        : isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    currentQuestion = quiz.nextQuestion;
    this.setState(() {
      questionText = currentQuestion.question;
      questionNumber = quiz.questionNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
          //this is our main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false)),
          ],
        ),
        new Container()
      ],
    );
  }
}
