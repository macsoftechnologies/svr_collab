import 'package:flutter/material.dart';
import 'package:svr/models/live_courses_model.dart';

import '../repositories/repositories.dart';

class LiveCoursesViewModel extends ChangeNotifier {

  List<LiveCoursesModel> _live_course = [];
  bool fetchingData = false;
  List<LiveCoursesModel> get liveCourses => _live_course;

  Future<void> fetchLiveCourse() async {
    fetchingData = true;
    try {
      _live_course = await Repositories().getLiveCourses();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load Live Courses: $e');
    }
    fetchingData = false;
  }
}