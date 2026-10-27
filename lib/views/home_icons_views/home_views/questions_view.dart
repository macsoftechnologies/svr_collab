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
  int attempts = 0;
  bool isReviewMode = false;

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
              attempts = model.attempts ?? 0;
              isReviewMode = attempts > 0;
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
        questionList.isNotEmpty
            ? (isReviewMode ? "Test Review" : "Test Questions")
            : "Questions",
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

  String? _getCorrectOptionLabel(Question question) {
    final ans = question.answer?.trim();
    if (ans == null || ans.isEmpty) return null;

    final upperAns = ans.toUpperCase();
    if (upperAns == 'A' || upperAns == 'OPTION A') return 'A';
    if (upperAns == 'B' || upperAns == 'OPTION B') return 'B';
    if (upperAns == 'C' || upperAns == 'OPTION C') return 'C';
    if (upperAns == 'D' || upperAns == 'OPTION D') return 'D';

    final normAns = ans.replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

    String norm(String? s) =>
        (s ?? '').trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

    if (question.a != null && norm(question.a) == normAns) return 'A';
    if (question.b != null && norm(question.b) == normAns) return 'B';
    if (question.c != null && norm(question.c) == normAns) return 'C';
    if (question.d != null && norm(question.d) == normAns) return 'D';

    return null;
  }

  void _retakeExam() {
    setState(() {
      isReviewMode = false;
      selectedAnswers.clear();
      answers.clear();
    });
    _controller.animateToPage(
      0,
      duration: _kDuration,
      curve: _kCurve,
    );
  }

  Widget _questionWidget(int index, List<Question> questions, double screenWidth) {
    final question = questions[index];
    final correctLabel = _getCorrectOptionLabel(question);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            /// Question + Options
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 6, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  if (isReviewMode)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.rate_review_outlined,
                                  color: Colors.blue.shade800, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "Attempted ($attempts) - Solutions Mode",
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: _retakeExam,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "Retake Exam",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      _radioOption(index, question, question.a, 'A', correctLabel),
                      _radioOption(index, question, question.b, 'B', correctLabel),
                      _radioOption(index, question, question.c, 'C', correctLabel),
                      _radioOption(index, question, question.d, 'D', correctLabel),
                    ],
                  ),
                  if (isReviewMode &&
                      question.answer != null &&
                      question.answer!.trim().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade600, width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Correct Answer:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  correctLabel != null
                                      ? "Option $correctLabel: ${question.answer!.trim()}"
                                      : question.answer!.trim(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Buttons at bottom
        Row(
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
              child: isReviewMode
                  ? (index == questions.length - 1
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                          ),
                          onPressed: _retakeExam,
                          child: const Text("Retake Exam",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                                duration: _kDuration, curve: _kCurve);
                          },
                          child: const Text("Next"),
                        ))
                  : (index == questions.length - 1
                      ? ElevatedButton(
                          onPressed: () {
                            _saveAnswer(index, question);
                            if (answers.length < 1) {
                              SnackBarsList().errorSnackBar(
                                  context,
                                  "You must answer at least 1 questions");
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
                        )),
            ),
          ],
        ),
      ],
    ),
  ),
);
  }

  Widget _radioOption(int index, Question question, String? value,
      String optionLabel, String? correctLabel) {
    if (value == null || value.isEmpty) return const SizedBox();

    final isCorrect = isReviewMode &&
        ((correctLabel != null && correctLabel == optionLabel) ||
            (question.answer != null &&
                value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase() ==
                    question.answer!
                        .trim()
                        .replaceAll(RegExp(r'\s+'), ' ')
                        .toLowerCase()));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withAlpha(20) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isCorrect
            ? Border.all(color: Colors.green.shade600, width: 1.5)
            : null,
      ),
      child: RadioListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "$optionLabel. $value",
                style: TextStyle(
                  fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                  color: isCorrect ? Colors.green.shade900 : Colors.black87,
                ),
              ),
            ),
            if (isCorrect)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "CORRECT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        value: value,
        groupValue: selectedAnswers[index],
        onChanged: isReviewMode
            ? null
            : (val) {
                setState(() {
                  selectedAnswers[index] = val.toString();
                });
              },
      ),
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
                "questions": answers, 
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
