import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svr/utils/colors.dart';
import 'package:svr/view_models/demo_course_view_model.dart';

import '../models/demo_courses_model.dart';

class DemoCourses extends StatefulWidget
{
  const DemoCourses({super.key});

  @override
  State<StatefulWidget> createState() => _DemoCourses();

}

class _DemoCourses extends State<DemoCourses> {

  @override
  void initState() {
    Provider.of<DemoCourseViewModel>(context, listen: false).fetchDemoCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("DemoCourses"),
      ),
      body: Consumer<DemoCourseViewModel>(builder: (context, viewModel, child) {
        if (!viewModel.fetchingData && viewModel.demoCourses.isEmpty) {
          return const Center(child: Text("empty"));
        }
        if (viewModel.fetchingData) {
          // While data is being fetched
          return const LinearProgressIndicator();
        } else {
          // If data is successfully fetched
          List<DemoCoursesModel> demoCourses = viewModel.demoCourses;
          return Column(
            children: [
              Flexible(
                  child: ListView.builder(
                      itemCount: demoCourses.length,
                      itemBuilder: (BuildContext context,int index){
                        return InkWell(
                          onTap: (){
                          },
                          child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.network("${demoCourses[index].demo_course_image}",width: 100,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${demoCourses[index].demo_course_name}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.55,
                                          child: Text("${demoCourses[index].description}"),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.55,
                                          child: Text("${demoCourses[index].video_name}"),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ),
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