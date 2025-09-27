import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/models/home_icons_models/courses_model.dart';
import 'package:svr/utils/global_keys.dart';
import 'package:svr/view_models/home_icons_view_models/studymaterial_view_model.dart';
import 'package:svr/views/home_icons_views/home_views/user_courses.dart';
import 'package:svr/views/login_page.dart';
import '../../utils/colors.dart';
import '../../utils/common_widgets.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<StatefulWidget> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  late Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    // Trigger the API call when the widget is initialized
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Every time the widget is inserted into the widget tree, fetch the courses again
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    // Clear previously fetched data so the page reloads the courses
    final viewModel = Provider.of<StudyMaterialViewModel>(context, listen: false);
    setState(() {
      // Trigger re-fetch by clearing previous courses data (if any)
      viewModel.myCourse.clear();
    });

    if (!viewModel.fetchingData) {
      await viewModel.fetchCourse(userId); // Fetch the courses for the user
    }
  }

  Future<void> showChoiceDialog(BuildContext context, String courseId, String courseName) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('courseid', courseId);
                  await prefs.setString('coursename', courseName);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserCoursesView(type: 'Online Classes'),
                    ),
                  );
                },
                child: Text('Online Class'),
              ),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('courseid', courseId);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserCoursesView(type: 'Materials'),
                    ),
                  );
                },
                child: Text('Materials'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "My Courses",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              logout();
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Consumer<StudyMaterialViewModel>(
        builder: (context, viewModel, child) {
          // If courses are not available, trigger an API fetch
          if (viewModel.myCourse.isEmpty && !viewModel.fetchingData) {
            _fetchCourses();
          }

          // Display loading indicator if data is being fetched
          if (viewModel.fetchingData) {
            return Center(
              child: CircularProgressIndicator(), // Loading indicator
            );
          }

          // Show message when no courses are available
          if (viewModel.myCourse.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No Courses Available"),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _fetchCourses(), // Retry logic
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            List<CoursesModel> courses = viewModel.myCourse;
            return Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.network(courses[index].courseImage ?? ''),
                          title: Text(courses[index].courseName ?? ''),
                          subtitle: Text(courses[index].name ?? ''),
                          trailing: Text(courses[index].amount ?? ''),
                          onTap: () {
                            final courseId = courses[index].courseId ?? '';
                            final courseName = courses[index].courseName ?? '';
                            showChoiceDialog(context, courseId, courseName);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void>logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear user data and set login status to false
    await prefs.remove('userData');
    // await prefs.setBool('isLoggedIn', false);

    // Navigate to login screen or any other screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
    );
  }
}
