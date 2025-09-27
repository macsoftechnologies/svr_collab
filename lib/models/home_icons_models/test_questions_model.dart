class TestQuestionsModel {
  int? teststatus;
  String? test;
  String? testId;
  List<QuestionsModel>? questions;

  TestQuestionsModel({this.teststatus, this.test, this.testId, this.questions});

  TestQuestionsModel.fromJson(Map<String, dynamic> json) {
    teststatus = json['teststatus'];
    test = json['test'];
    testId = json['test_id'];
    if (json['question'] != null) {
      questions = <QuestionsModel>[];
      json['question'].forEach((v) {
        questions!.add(QuestionsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teststatus'] = teststatus;
    data['test'] = test;
    data['test_id'] = testId;
    if (questions != null) {
      data['question'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionsModel {
  String? questionId;
  String? question;
  String? test;
  String? a;
  String? b;
  String? c;
  String? d;
  String? answer;
  String? testname;

  QuestionsModel(
      {this.questionId,
        this.question,
        this.test,
        this.a,
        this.b,
        this.c,
        this.d,
        this.answer,
        this.testname});

  QuestionsModel.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    test = json['test'];
    a = json['A'];
    b = json['B'];
    c = json['C'];
    d = json['D'];
    answer = json['answer'];
    testname = json['testname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question'] = question;
    data['test'] = test;
    data['A'] = a;
    data['B'] = b;
    data['C'] = c;
    data['D'] = d;
    data['answer'] = answer;
    data['testname'] = testname;
    return data;
  }
}
