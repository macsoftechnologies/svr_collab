import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/views/home_icons_views/home_views/subjects_view.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_widgets.dart';

class UserCoursesView extends StatefulWidget
{
  final String type;
  const UserCoursesView({super.key, required this.type});

  @override
  State<StatefulWidget> createState() => _UserCoursesView();
}

class _UserCoursesView extends State<UserCoursesView> {
  late String courseId,courseName;
  @override
  void initState() {
    getData();

    super.initState();
  }
  Map<String,dynamic>? myCoursesData;

  getData()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMap = prefs.getString('userData').toString();
    courseId = prefs.getString('courseid')!;
    courseName = prefs.getString('coursename')!;
    myCoursesData = json.decode(encodedMap);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: CommonWidgets().appBar("Select Course",context),
      body: myCoursesData == null ? Container(
          child: Column(
          children: [


          const LinearProgressIndicator(),
            SizedBox(height: 30,),
            Text("Please select your courses in my courses page"),
        ]
      ), ): Card(
        child: InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute (
                builder: (BuildContext context) => SubjectsView(type : widget.type,courseId:courseId),//myCoursesData?["course_id"]),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Text("${courseName}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),textAlign: TextAlign.center,),
          ),
        ),
      ),
    );
  }
}