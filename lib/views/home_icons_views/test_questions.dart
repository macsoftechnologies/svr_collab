// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:svr/models/home_icons_models/test_questions_model.dart';
// import 'package:svr/view_models/home_icons_view_models/test_questions_view_model.dart';
// import 'package:svr/views/home_icons_views/home_views/questions_view.dart';
// import '../../utils/colors.dart';
// import '../../utils/common_widgets.dart';

// enum BestTutorSite { javatpoint, w3schools, tutorialandexample ,tu}

// class TestQuestions extends StatefulWidget {
//   const TestQuestions({super.key});

//   @override
//   State<StatefulWidget> createState() => _TestQuestions();
// }

// class _TestQuestions extends State<TestQuestions> {

//   @override
//   void initState() {
//     Provider.of<TestQuestionsViewModel>(context, listen: false).fetchTestQuestions(context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: secondaryColor,
//       appBar: CommonWidgets().appBar("Select Test",context),
//       body: Consumer<TestQuestionsViewModel>(builder: (context, viewModel, child) {
//         if (!viewModel.fetchingData && viewModel.testQuestionsInfo.isEmpty) {
//           Provider.of<TestQuestionsViewModel>(context, listen: false).fetchTestQuestions(context);
//           return const Center(child: Text("empty"),);
//         }
//         if (viewModel.fetchingData) {
//           // While data is being fetched
//           return const LinearProgressIndicator();
//         } else {
//           // If data is successfully fetched
//           List<TestQuestionsModel> tests = viewModel.testQuestionsInfo;
//           return tests.isEmpty ? const Center(child: Text("This user tests are not available"),) : Column(
//             children: [
//               Flexible(
//                 child: ListView.builder(
//                     itemCount: tests.length,
//                     itemBuilder: (BuildContext context,int index){
//                       return tests[index].teststatus == 1 ? Container() : Card(
//                           child: InkWell(
//                               onTap: (){
//                                 Navigator.pop(context);
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute (
//                                     builder: (BuildContext context) => QuestionsView(questions : tests[index].questions),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                   children: [
//                                     // subjects[index].subjectImage != "" ? Image.network("${subjects[index].subjectImage}") :
//                                     const Icon(Icons.note_alt_outlined,size: 30,),
//                                     SizedBox(
//                                       width: MediaQuery.of(context).size.width*0.8,
//                                       child: Text("${tests[index].test}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                                     )
//                                   ],
//                                 ),
//                               )
//                           )
//                       );
//                     }
//                 ),
//               )
//             ],
//           );
//         }
//       }),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:svr/models/test_question_model.dart';
import 'package:svr/views/home_icons_views/home_views/questions_view.dart';
import '../../utils/colors.dart';
import '../../utils/common_widgets.dart';

enum BestTutorSite { javatpoint, w3schools, tutorialandexample, tu }

class TestQuestions extends StatefulWidget {
  final String courseId;

  const TestQuestions({
    super.key,
    required this.courseId,
  });

  @override
  State<StatefulWidget> createState() => _TestQuestions();
}

class _TestQuestions extends State<TestQuestions> {
  bool isLoading = false;

  GetTestQuestionsModel? pushintoTestquestionModel;
  List<Result> gettestquestions = [];

  @override
  void initState() {
    super.initState();
    _getTestQuestions();
  }

  Future<void> _getTestQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();

      final response = await dio.post(
        'https://svracademy.in/services/users/getCoursebasedtests',
        data: {
          'course_id': widget.courseId,
        },
        options: Options(
          headers: {
            'Auth-key': 'svrapi',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> jsonResponse =
            response.data as Map<String, dynamic>;

        if (jsonResponse['message'] == 'Success') {
          pushintoTestquestionModel =
              GetTestQuestionsModel.fromJson(jsonResponse);

          setState(() {
            gettestquestions = 
                pushintoTestquestionModel?.result ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching test questions: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().appBar("Select Test", context),
      body: isLoading
          ? const LinearProgressIndicator()
          : gettestquestions.isEmpty
              ? const Center(
                  child: Text("This user tests are not available"),
                )
              : Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        itemCount: gettestquestions.length,
                        itemBuilder: (BuildContext context, int index) {
                          final test = gettestquestions[index];
                          return Card(
                            color:Colors.lightBlue[100],
                            child: InkWell(
                              onTap: () {
                                 Navigator.pop(context);
                                  Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => QuestionsView(
            testId: test.testId ?? "",
          ),
        ),
      );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      color: Colors.black,
                                      Icons.note_alt_outlined,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.8,
                                      child: Text(
                                        "${test.test}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Colors.black
                                        ),
                                      ),
                                    ),
                                  
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
