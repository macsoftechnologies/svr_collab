import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:svr/utils/colors.dart';
import 'package:svr/view_models/demo_course_view_model.dart';
import 'package:svr/view_models/home_icons_view_models/materials_view_model.dart';
import 'package:svr/view_models/home_icons_view_models/offline_classes_view_model.dart';
import 'package:svr/view_models/home_icons_view_models/online_classes_view_model.dart';
import 'package:svr/view_models/home_icons_view_models/profile_view_model.dart';
import 'package:svr/view_models/home_icons_view_models/studymaterial_view_model.dart';
import 'package:svr/view_models/home_icons_view_models/test_questions_view_model.dart';
import 'package:svr/view_models/subjects_view_model.dart';
import 'package:svr/view_models/live_courses_view_model.dart';
import 'package:svr/view_models/login_view_model.dart';
import 'package:svr/views/home_icons_views/offline_download_page.dart';
import 'package:svr/views/splash_screen.dart';

Future<void> main() async {
  Razorpay _razorpay = Razorpay();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => DemoCourseViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => LiveCoursesViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => SubjectsViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => MaterialsViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => OnlineClassesViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => TestQuestionsViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProfileViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => StudyMaterialViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => OfflineClassesViewModel(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SVR Academy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
