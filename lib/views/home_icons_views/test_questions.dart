import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svr/models/home_icons_models/test_questions_model.dart';
import 'package:svr/view_models/home_icons_view_models/test_questions_view_model.dart';
import 'package:svr/views/home_icons_views/home_views/questions_view.dart';
import '../../utils/colors.dart';
import '../../utils/common_widgets.dart';

enum BestTutorSite { javatpoint, w3schools, tutorialandexample ,tu}

class TestQuestions extends StatefulWidget {
  const TestQuestions({super.key});

  @override
  State<StatefulWidget> createState() => _TestQuestions();
}

class _TestQuestions extends State<TestQuestions> {

  @override
  void initState() {
    Provider.of<TestQuestionsViewModel>(context, listen: false).fetchTestQuestions(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: CommonWidgets().appBar("Select Test",context),
      body: Consumer<TestQuestionsViewModel>(builder: (context, viewModel, child) {
        if (!viewModel.fetchingData && viewModel.testQuestionsInfo.isEmpty) {
          Provider.of<TestQuestionsViewModel>(context, listen: false).fetchTestQuestions(context);
          return const Center(child: Text("empty"),);
        }
        if (viewModel.fetchingData) {
          // While data is being fetched
          return const LinearProgressIndicator();
        } else {
          // If data is successfully fetched
          List<TestQuestionsModel> tests = viewModel.testQuestionsInfo;
          return tests.isEmpty ? const Center(child: Text("This user tests are not available"),) : Column(
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: tests.length,
                    itemBuilder: (BuildContext context,int index){
                      return tests[index].teststatus == 1 ? Container() : Card(
                          child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute (
                                    builder: (BuildContext context) => QuestionsView(questions : tests[index].questions),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // subjects[index].subjectImage != "" ? Image.network("${subjects[index].subjectImage}") :
                                    const Icon(Icons.note_alt_outlined,size: 30,),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      child: Text("${tests[index].test}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                    )
                                  ],
                                ),
                              )
                          )
                      );
                    }
                ),
              )
            ],
          );
        }
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
