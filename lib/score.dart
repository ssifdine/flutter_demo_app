import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  final int _score;
  final VoidCallback _resetQuiz;
  final int _numberOfQuestions;

  Score(this._score, this._resetQuiz, this._numberOfQuestions);

  String get resultPhrase {
    return 'You scored $_score out of $_numberOfQuestions';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resultPhrase,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetQuiz,
            child: Text("Restart Quiz"),
          ),
        ],
      ),
    );
  }
}
