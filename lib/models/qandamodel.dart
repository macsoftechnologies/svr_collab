class GetQuestionAndAnswersModel {
  final int? status;
  final String? message;
  final List<Testdetails>? testdetails;
  final int? numberofquestions;
  final int? attempts;
  final int? correctanswers;
  final int? wronganswers;

  GetQuestionAndAnswersModel({
    this.status,
    this.message,
    this.testdetails,
    this.numberofquestions,
    this.attempts,
    this.correctanswers,
    this.wronganswers,
  });

  factory GetQuestionAndAnswersModel.fromJson(Map<String, dynamic> json) {
    return GetQuestionAndAnswersModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      testdetails: json['testdetails'] != null
          ? (json['testdetails'] as List)
              .map((e) => Testdetails.fromJson(e))
              .toList()
          : null,
      numberofquestions: json['numberofquestions'] as int?,
      attempts: json['attempts'] as int?,
      correctanswers: json['correctanswers'] as int?,
      wronganswers: json['wronganswers'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'testdetails': testdetails?.map((e) => e.toJson()).toList(),
        'numberofquestions': numberofquestions,
        'attempts': attempts,
        'correctanswers': correctanswers,
        'wronganswers': wronganswers,
      };
}

class Testdetails {
  final String? test;
  final List<Question>? question;

  Testdetails({this.test, this.question});

  factory Testdetails.fromJson(Map<String, dynamic> json) {
    return Testdetails(
      test: json['test'] as String?,
      question: json['question'] != null
          ? (json['question'] as List)
              .map((e) => Question.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'test': test,
        'question': question?.map((e) => e.toJson()).toList(),
      };
}

class Question {
  final String? questionId;
  final String? question;
  final String? answer;
  final String? a;
  final String? b;
  final String? c;
  final String? d;

  Question({this.questionId, this.question, this.answer, this.a, this.b, this.c, this.d});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'] as String?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      a: json['A'] as String?,
      b: json['B'] as String?,
      c: json['C'] as String?,
      d: json['D'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'question': question,
        'answer': answer,
        'A': a,
        'B': b,
        'C': c,
        'D': d,
      };
}
