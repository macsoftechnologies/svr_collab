
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
  bool button = false;
  String submission = "";
  bool isLoading = false;  // Track loading state

  final _controller = PageController();
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    questions = widget.questions!;
    super.initState();
  }

  List answers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: CommonWidgets().appBar("${questions[0].testname}",context),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: PageView.builder(
                controller: _controller,
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return question(index, questions);
                },
              ),
            ),
            if (isLoading)  // Show the progress indicator and message while loading
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),  // Progress indicator
                    SizedBox(height: 16),  // Add some space between the progress and text
                    Text(
                      'Please wait...',  // Message
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(5),
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (answers.length < 14) {
              SnackBarsList().errorSnackBar(
                  context, "You must answer at least 15 questions");
            } else {
              if (isQuestionIdExists(_questionId)) {
                updateAnswer(_questionId, _selectedValue);
              } else {
                addAnswer(_questionId, _selectedValue);
              }
              submitBox();
            }
          },
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(primaryColor)),
          child: const Text("Submit"),
        ),
      ),
    );
  }

  String _selectedValue = "";
  int _questionId = 0;

  Widget question(index, List<QuestionsModel> questions) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                  bottom: 0.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _controller.previousPage(
                                    duration: _kDuration, curve: _kCurve);
                              });
                            },
                            child: const Text("Prev")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (answers.isEmpty) {
                                  addAnswer(_questionId, _selectedValue);
                                } else {
                                  if (isQuestionIdExists(_questionId)) {
                                    updateAnswer(_questionId, _selectedValue);
                                  } else {
                                    addAnswer(_questionId, _selectedValue);
                                  }
                                }
                                _controller.nextPage(
                                    duration: _kDuration, curve: _kCurve);
                                _selectedValue = "";
                              });
                            },
                            child: const Text("Next")),
                      ],
                    ),
                  )
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: HtmlWidget(
                                "${questions[index].question}",
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 350,
                      child: Column(
                        children: <Widget>[
                          RadioListTile(
                            title: Text('${questions[index].a}'),
                            value: questions[index]
                                .a,
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
                            value: questions[index]
                                .b,
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
                            value: questions[index]
                                .c,
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
                            value: questions[index]
                                .d,
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
          )),
    );
  }

  void addAnswer(questionId, answer) {
    answers.add(
      {"question_id": questionId, "answer": answer},
    );
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
    for (var data in answers) {
      if (data['question_id'] == questionId) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  submitBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Final Submission'),
          content: const Text('Do you want submit the test..?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(errorColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: whiteColor)),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(successColor)),
              onPressed: () async {
                // Show loading indicator before API call
                setState(() {
                  isLoading = true;
                });

                Map<String, dynamic> submissionData = {
                  "user_id": userId,
                  "test_id": questions[0].test,
                  "questions": answers
                };

                print(submissionData);

                // Perform the API call and wait for the response
                Map<String, dynamic> response =
                await Repositories().getSubmitTest(submissionData);

                // Hide loading indicator after API call is complete
                setState(() {
                  isLoading = false;
                });

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
}
