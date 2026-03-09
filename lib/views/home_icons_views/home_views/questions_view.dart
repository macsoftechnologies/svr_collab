// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:svr/models/home_icons_models/test_questions_model.dart';
// import 'package:svr/utils/global_keys.dart';
// import 'package:svr/utils/snackbars_list.dart';

// import '../../../repositories/repositories.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/common_widgets.dart';
// import '../test_submission_view.dart';

// class QuestionsView extends StatefulWidget {
//   final List<QuestionsModel>? questions;
//   const QuestionsView({super.key, required this.questions});

//   @override
//   State<StatefulWidget> createState() => _QuestionsView();
// }

// class _QuestionsView extends State<QuestionsView> {
//   List<QuestionsModel> questions = [];
//   List answers = [];
//   bool isLoading = false;

//   final _controller = PageController();
//   static const _kDuration = Duration(milliseconds: 300);
//   static const _kCurve = Curves.ease;

//   String _selectedValue = "";
//   int _questionId = 0;

//   @override
//   void initState() {
//     questions = widget.questions!;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: secondaryColor,
//       appBar: CommonWidgets().appBar("${questions[0].testname}", context),
//       body: Stack(
//         children: [
//           Container(
//             margin: const EdgeInsets.all(5),
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                   child: PageView.builder(
//                     controller: _controller,
//                     itemCount: questions.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return question(index, questions);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isLoading)
//             Center(
//               child: Container(
//                 color: Colors.white70,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 16),
//                     Text(
//                       'Please wait...',
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget question(int index, List<QuestionsModel> questions) {
//     return Card(
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           children: [
//             Positioned(
//               bottom: 30,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//   // Prev Button
//   ElevatedButton(
//     onPressed: () {
//       if (index > 0) {
//         _controller.previousPage(
//           duration: _kDuration,
//           curve: _kCurve,
//         );
//       }
//     },
//     child: const Text("Prev"),
//   ),

//   // Skip to Last Button
//   ElevatedButton(
//     onPressed: () {
//       _controller.animateToPage(
//         questions.length - 1,
//         duration: _kDuration,
//         curve: _kCurve,
//       );
//     },
//     child: const Text("Skip to Last"),
//   ),

//   // Next or Submit Button
//   (index == questions.length - 1)
//       ? ElevatedButton(
//           onPressed: () {
//             setState(() {
//               if (_selectedValue.isNotEmpty) {
//                 if (isQuestionIdExists(_questionId)) {
//                   updateAnswer(_questionId, _selectedValue);
//                 } else {
//                   addAnswer(_questionId, _selectedValue);
//                 }
//               }
//             });

//             if (answers.length < 15) {
//               SnackBarsList().errorSnackBar(
//                 context,
//                 "You must answer at least 15 questions",
//               );
//             } else {
//               submitBox();
//             }
//           },
//           child: const Text("Submit"),
//         )
//       : ElevatedButton(
//           onPressed: () {
//             setState(() {
//               if (_selectedValue.isNotEmpty) {
//                 if (isQuestionIdExists(_questionId)) {
//                   updateAnswer(_questionId, _selectedValue);
//                 } else {
//                   addAnswer(_questionId, _selectedValue);
//                 }
//               }
//               _selectedValue = "";
//               _controller.nextPage(
//                 duration: _kDuration,
//                 curve: _kCurve,
//               );
//             });
//           },
//           child: const Text("Next"),
//         ),
// ],

              
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(5),
//                           child: Text(
//                             "${index + 1}.",
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(5),
//                           height: MediaQuery.of(context).size.height * 0.3,
//                           width: MediaQuery.of(context).size.width * 0.7,
//                           child: SingleChildScrollView(
//                             child: HtmlWidget("${questions[index].question}"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 350,
//                     child: Column(
//                       children: <Widget>[
//                         RadioListTile(
//                           title: Text('${questions[index].a}'),
//                           value: questions[index].a,
//                           groupValue: _selectedValue,
//                           onChanged: (value) {
//                             setState(() {
//                               _questionId = int.parse(
//                                   questions[index].questionId.toString());
//                               _selectedValue = value.toString();
//                             });
//                           },
//                         ),
//                         RadioListTile(
//                           title: Text('${questions[index].b}'),
//                           value: questions[index].b,
//                           groupValue: _selectedValue,
//                           onChanged: (value) {
//                             setState(() {
//                               _questionId = int.parse(
//                                   questions[index].questionId.toString());
//                               _selectedValue = value.toString();
//                             });
//                           },
//                         ),
//                         RadioListTile(
//                           title: Text('${questions[index].c}'),
//                           value: questions[index].c,
//                           groupValue: _selectedValue,
//                           onChanged: (value) {
//                             setState(() {
//                               _questionId = int.parse(
//                                   questions[index].questionId.toString());
//                               _selectedValue = value.toString();
//                             });
//                           },
//                         ),
//                         RadioListTile(
//                           title: Text('${questions[index].d}'),
//                           value: questions[index].d,
//                           groupValue: _selectedValue,
//                           onChanged: (value) {
//                             setState(() {
//                               _questionId = int.parse(
//                                   questions[index].questionId.toString());
//                               _selectedValue = value.toString();
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void addAnswer(questionId, answer) {
//     answers.add({
//       "question_id": questionId,
//       "answer": answer,
//     });
//   }

//   void updateAnswer(int questionId, String newAnswer) {
//     for (int i = 0; i < answers.length; i++) {
//       if (answers[i]["question_id"] == questionId) {
//         answers[i]["answer"] = newAnswer;
//         break;
//       }
//     }
//   }

//   bool isQuestionIdExists(int questionId) {
//     return answers.any((data) => data['question_id'] == questionId);
//   }

// void submitBox() {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         title: const Text('Final Submission'),
//         content: const Text('Do you want to submit the test..?'),
//         actionsAlignment: MainAxisAlignment.spaceBetween,
//         actions: <Widget>[
//           TextButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(errorColor)),
//             onPressed: () {
//               Navigator.of(dialogContext).pop(); // Close dialog only
//             },
//             child: Text('Close', style: TextStyle(color: whiteColor)),
//           ),
//           TextButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(successColor)),
//             onPressed: () async {
//               // Close the dialog immediately
//               Navigator.of(dialogContext).pop();

//               setState(() {
//                 isLoading = true;
//               });

//               Map<String, dynamic> submissionData = {
//                 "user_id": userId,
//                 "test_id": questions[0].test,
//                 "questions": answers
//               };

//               Map<String, dynamic> response =
//                   await Repositories().getSubmitTest(submissionData);

//               if (!mounted) return;

//               setState(() {
//                 isLoading = false;
//               });

//               // Navigate to next screen with widget's outer context, safely
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) =>
//                       TestSubmissionView(response: response),
//                 ),
//               );
//             },
//             child: Text(
//               'Submit',
//               style: TextStyle(color: whiteColor),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:svr/models/qandamodel.dart';
import 'package:svr/utils/global_keys.dart';
import 'package:svr/utils/snackbars_list.dart';
import '../../../repositories/repositories.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_widgets.dart';
import '../test_submission_view.dart';

class QuestionsView extends StatefulWidget {
  final String? testId;

  const QuestionsView({super.key, required this.testId});

  @override
  State<StatefulWidget> createState() => _QuestionsView();
}

class _QuestionsView extends State<QuestionsView> {
  List<Question> questionList = [];
  Map<int, String> selectedAnswers = {}; // per-question selected value
  List<Map<String, dynamic>> answers = [];
  bool isLoading = false;

  final PageController _controller = PageController();
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    _getTestQuestionsAndAnswer();
  }

  Future<void> _getTestQuestionsAndAnswer() async {
    setState(() => isLoading = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://svracademy.in/services/questions/getTestDetails',
        data: {
          'user_id': userId ?? "",
          'test_id': widget.testId ?? "",
        },
        options: Options(headers: {'Auth-key': 'svrapi'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> jsonResponse =
            response.data as Map<String, dynamic>;

        if (jsonResponse['message'] == 'Success') {
          final model = GetQuestionAndAnswersModel.fromJson(jsonResponse);
          if (model.testdetails != null && model.testdetails!.isNotEmpty) {
            setState(() {
              questionList = model.testdetails!.first.question ?? [];
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching questions: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().appBar(
        questionList.isNotEmpty ? "Test Questions" : "Questions",
        context,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(), // prevent swipe
                    itemCount: questionList.length,
                    itemBuilder: (context, index) =>
                        _questionWidget(index, questionList, screenWidth),
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
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _questionWidget(int index, List<Question> questions, double screenWidth) {
    final question = questions[index];
    final selectedValue = selectedAnswers[index];

    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            /// Question + Options
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Expanded(
                          child: HtmlWidget(question.question ?? ""),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      _radioOption(index, question, question.a, 'A'),
                      _radioOption(index, question, question.b, 'B'),
                      _radioOption(index, question, question.c, 'C'),
                      _radioOption(index, question, question.d, 'D'),
                    ],
                  ),
                ],
              ),
            ),

            // Buttons at bottom
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: screenWidth * 0.28,
                    child: ElevatedButton(
                     
                      onPressed: index > 0
                          ? () =>
                              _controller.previousPage(
                                  duration: _kDuration, curve: _kCurve)
                          : null,
                      child: const Text("Prev"),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.28,
                    child: ElevatedButton(
                      onPressed: () => _controller.animateToPage(
                          questions.length - 1,
                          duration: _kDuration,
                          curve: _kCurve),
                      child:  Text("Skip to Last", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.28,
                    child: (index == questions.length - 1)
                        ? ElevatedButton(
                            onPressed: () {
                              _saveAnswer(index, question);
                              if (answers.length < 15) {
                                SnackBarsList().errorSnackBar(
                                    context,
                                    "You must answer at least 15 questions");
                              } else {
                                _submitBox();
                              }
                            },
                            child: const Text("Submit"),
                          )
                        : ElevatedButton(
                         
                            onPressed: () {
                              if (selectedAnswers[index] == null) {
                                SnackBarsList().errorSnackBar(
                                    context, "Please select an option");
                                return;
                              }
                              _saveAnswer(index, question);
                              _controller.nextPage(
                                  duration: _kDuration, curve: _kCurve);
                            },
                            child: const Text("Next"),
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

  Widget _radioOption(int index, Question question, String? value, String optionLabel) {
    if (value == null || value.isEmpty) return const SizedBox();

    return RadioListTile(
      title: Text("$optionLabel. $value"),
      value: value,
      groupValue: selectedAnswers[index],
      onChanged: (val) {
        setState(() {
          selectedAnswers[index] = val.toString();
        });
      },
    );
  }

  void _saveAnswer(int index, Question question) {
    final selectedValue = selectedAnswers[index];
    if (selectedValue == null || selectedValue.isEmpty) return;

    // FIXED: Use questionId instead of question text
    int qId = int.parse(question.questionId ?? "0");

    if (answers.any((a) => a["question_id"] == qId)) {
      answers.firstWhere((a) => a["question_id"] == qId)["answer"] =
          selectedValue;
    } else {
      answers.add({
        "question_id": qId,
        "answer": selectedValue,
      });
    }
  }

void _submitBox() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Final Submission'),
        content: const Text('Do you want to submit the test..?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              setState(() => isLoading = true);

              // Prepare submission payload
              final Map<String, dynamic> submissionData = {
                "user_id": userId ?? "",
                "test_id": widget.testId ?? "",
                "questions": answers, // already contains question_id & answer
              };

              try {
                final response =
                    await Repositories().getSubmitTest(submissionData);

                if (!mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TestSubmissionView(response: response),
                  ),
                );
              } catch (e) {
                SnackBarsList().errorSnackBar(context, "Submission failed: $e");
              } finally {
                if (mounted) setState(() => isLoading = false);
              }
            },
            child: const Text("Submit"),
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
