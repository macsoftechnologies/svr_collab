import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/models/home_icons_models/courses_model.dart';
import 'package:svr/utils/global_keys.dart';
import 'package:svr/view_models/home_icons_view_models/studymaterial_view_model.dart';
import 'package:svr/views/home_icons_views/home_views/user_courses.dart';
import 'package:svr/views/home_icons_views/test_questions.dart';
import 'package:svr/views/login_page.dart';
import '../../utils/colors.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<StatefulWidget> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  late Map<String, dynamic> userData = {};
 bool _toastShown = false;

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



void _showToastAndBack() {
  if (_toastShown) return; // show only once
  _toastShown = true;

  // Show the toast
  Fluttertoast.showToast(
    msg: "Your Course Cart is Empty,  Please Purchase Any Course",
    toastLength: Toast.LENGTH_SHORT, 
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.blue[900],
    textColor: Colors.white,
    fontSize: 13.0,
  );

  // Wait 6 seconds and navigate back
  Future.delayed(const Duration(seconds: 3), () {
    if (!mounted) return;
    Navigator.of(context).pop(); // go back
  });
}

 Future<void> _fetchCourses() async {
  final viewModel = Provider.of<StudyMaterialViewModel>(context, listen: false);

  // Avoid re-fetching if already fetching
  if (viewModel.fetchingData) return;

  try {
  
    viewModel.myCourse.clear();

    // Fetch new course data
    await viewModel.fetchCourse(userId);

    // Optionally: You could handle cases where no data is fetched
   if (viewModel.myCourse.isEmpty) {
_showToastAndBack();

}

  } catch (e) {
    print('Failed to fetch courses: $e');

    // Optionally: Show an error message to the user
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Failed to load courses. Please try again.')),
    // );
  }
}
Future<void> showChoiceDialog(
  BuildContext context,
  String courseId,
  String courseName,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        
        ),
        title: const Text(
          'Choose an option',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
                style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white
                ),
              icon: const Icon(Icons.live_tv),
              label: const Text('Online Classes'),
              onPressed: () async {
                SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('courseid', courseId);
                await prefs.setString('coursename', courseName);

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserCoursesView(type: 'Online Classes'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
                style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white
                ),
              icon: const Icon(Icons.menu_book),
              label: const Text('Study Materials'),
              onPressed: () async {
                SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('courseid', courseId);

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserCoursesView(type: 'Materials'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white
                ),
              icon: const Icon(Icons.quiz),
              label: const Text('Tests',),
              onPressed: () {
                
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  TestQuestions(courseId: courseId)),
          );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
          ),
        ],
      );
    },
  );
}


  // Future<void> showChoiceDialog(BuildContext context, String courseId, String courseName) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Choose an option'),
  //         content: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             ElevatedButton(
  //               onPressed: () async {
  //                 SharedPreferences prefs = await SharedPreferences.getInstance();
  //                 await prefs.setString('courseid', courseId);
  //                 await prefs.setString('coursename', courseName);

  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => UserCoursesView(type: 'Online Classes'),
  //                   ),
  //                 );
  //               },
  //               child: Text('Online Class'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 SharedPreferences prefs = await SharedPreferences.getInstance();
  //                 await prefs.setString('courseid', courseId);

  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => UserCoursesView(type: 'Materials'),
  //                   ),
  //                 );
  //               },
  //               child: Text('Materials'),
  //             ),
  //             ElevatedButton(
                
  //               onPressed: () async {
                 

                
  //               },
  //               child: Text('Test'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          "My Courses",
          style: TextStyle(color: Colors.white, ),
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
                        color: Colors.lightBlue[100],
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: 
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.network(courses[index].courseImage ?? ''),
                          ),
                          title: Text(courses[index].courseName ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                          // subtitle: Text(courses[index].name ?? ''),
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
