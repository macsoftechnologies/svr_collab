import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:svr/models/home_icons_models/test_questions_model.dart';
import 'package:svr/utils/global_keys.dart';
import 'package:svr/utils/snackbars_list.dart';

import '../../../repositories/repositories.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_widgets.dart';
import '../test_submission_view.dart';

class QuestionsView extends StatefulWidget {
  final List<QuestionsModel>? questions;
  const QuestionsView({super.key, required this.questions});

  @override
  State<StatefulWidget> createState() => _QuestionsView();
}

class _QuestionsView extends State<QuestionsView> {
  List<QuestionsModel> questions = [];
  List answers = [];
  bool isLoading = false;

  final _controller = PageController();
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  String _selectedValue = "";
  int _questionId = 0;

  @override
  void initState() {
    questions = widget.questions!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: CommonWidgets().appBar("${questions[0].testname}", context),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return question(index, questions);
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: Container(
                color: Colors.white70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget question(int index, List<QuestionsModel> questions) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 30,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
  // Prev Button
  ElevatedButton(
    onPressed: () {
      if (index > 0) {
        _controller.previousPage(
          duration: _kDuration,
          curve: _kCurve,
        );
      }
    },
    child: const Text("Prev"),
  ),

  // Skip to Last Button
  ElevatedButton(
    onPressed: () {
      _controller.animateToPage(
        questions.length - 1,
        duration: _kDuration,
        curve: _kCurve,
      );
    },
    child: const Text("Skip to Last"),
  ),

  // Next or Submit Button
  (index == questions.length - 1)
      ? ElevatedButton(
          onPressed: () {
            setState(() {
              if (_selectedValue.isNotEmpty) {
                if (isQuestionIdExists(_questionId)) {
                  updateAnswer(_questionId, _selectedValue);
                } else {
                  addAnswer(_questionId, _selectedValue);
                }
              }
            });

            if (answers.length < 15) {
              SnackBarsList().errorSnackBar(
                context,
                "You must answer at least 15 questions",
              );
            } else {
              submitBox();
            }
          },
          child: const Text("Submit"),
        )
      : ElevatedButton(
          onPressed: () {
            setState(() {
              if (_selectedValue.isNotEmpty) {
                if (isQuestionIdExists(_questionId)) {
                  updateAnswer(_questionId, _selectedValue);
                } else {
                  addAnswer(_questionId, _selectedValue);
                }
              }
              _selectedValue = "";
              _controller.nextPage(
                duration: _kDuration,
                curve: _kCurve,
              );
            });
          },
          child: const Text("Next"),
        ),
],

              
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "${index + 1}.",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: SingleChildScrollView(
                            child: HtmlWidget("${questions[index].question}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 350,
                    child: Column(
                      children: <Widget>[
                        RadioListTile(
                          title: Text('${questions[index].a}'),
                          value: questions[index].a,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _questionId = int.parse(
                                  questions[index].questionId.toString());
                              _selectedValue = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('${questions[index].b}'),
                          value: questions[index].b,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _questionId = int.parse(
                                  questions[index].questionId.toString());
                              _selectedValue = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('${questions[index].c}'),
                          value: questions[index].c,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _questionId = int.parse(
                                  questions[index].questionId.toString());
                              _selectedValue = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('${questions[index].d}'),
                          value: questions[index].d,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _questionId = int.parse(
                                  questions[index].questionId.toString());
                              _selectedValue = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addAnswer(questionId, answer) {
    answers.add({
      "question_id": questionId,
      "answer": answer,
    });
  }

  void updateAnswer(int questionId, String newAnswer) {
    for (int i = 0; i < answers.length; i++) {
      if (answers[i]["question_id"] == questionId) {
        answers[i]["answer"] = newAnswer;
        break;
      }
    }
  }

  bool isQuestionIdExists(int questionId) {
    return answers.any((data) => data['question_id'] == questionId);
  }

void submitBox() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Final Submission'),
        content: const Text('Do you want to submit the test..?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(errorColor)),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog only
            },
            child: Text('Close', style: TextStyle(color: whiteColor)),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(successColor)),
            onPressed: () async {
              // Close the dialog immediately
              Navigator.of(dialogContext).pop();

              setState(() {
                isLoading = true;
              });

              Map<String, dynamic> submissionData = {
                "user_id": userId,
                "test_id": questions[0].test,
                "questions": answers
              };

              Map<String, dynamic> response =
                  await Repositories().getSubmitTest(submissionData);

              if (!mounted) return;

              setState(() {
                isLoading = false;
              });

              // Navigate to next screen with widget's outer context, safely
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      TestSubmissionView(response: response),
                ),
              );
            },
            child: Text(
              'Submit',
              style: TextStyle(color: whiteColor),
            ),
          ),
        ],
      );
    },
  );
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
