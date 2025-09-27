import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svr/models/subjects_model.dart';
import 'package:svr/view_models/subjects_view_model.dart';
import 'package:svr/views/home_icons_views/online_classes.dart';

import '../../../../utils/colors.dart';
import '../study_materials.dart';

class SubjectsView extends StatefulWidget
{
  final String courseId;
  final String type;
  const SubjectsView({super.key, required this.courseId, required this.type});

  @override
  State<StatefulWidget> createState() => _SubjectsView();

}

class _SubjectsView extends State<SubjectsView>
{

  @override
  void initState() {
    Provider.of<SubjectsViewModel>(context, listen: false).fetchSubjects(widget.courseId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Select Subject"),
      ),
      body: Consumer<SubjectsViewModel>(builder: (context, viewModel, child) {
        if (!viewModel.fetchingData && viewModel.subjectsInfo.isEmpty) {
          return const Center(child: Text("empty"));
        }
        if (viewModel.fetchingData) {
          // While data is being fetched
          return const LinearProgressIndicator();
        }  else {
          // If data is successfully fetched
          List<SubjectsModel> subjects = viewModel.subjectsInfo;
          return Column(
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (BuildContext context,int index){
                      return Card(
                          child: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute (
                                    builder: (BuildContext context) => widget.type == "Online Classes" ? OnlineClasses(subjectId:"${subjects[index].subjectId}") : StudyMaterials(subjectId:"${subjects[index].subjectId}"),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // subjects[index].subjectImage != "" ? Image.network("${subjects[index].subjectImage}") :
                                    const Icon(Icons.file_copy_rounded,size: 30,),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      child: Text("${subjects[index].subjectName}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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
}