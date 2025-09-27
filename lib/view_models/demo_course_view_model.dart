import 'package:flutter/material.dart';

import '../models/demo_courses_model.dart';
import '../repositories/repositories.dart';

class DemoCourseViewModel extends ChangeNotifier {
  List<DemoCoursesModel> _demo_course = [];
  bool fetchingData = false;
  List<DemoCoursesModel> get demoCourses => _demo_course;

  Future<void> fetchDemoCourse() async {
    fetchingData = true;
    try {
      _demo_course = await Repositories().getDemoCourses();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load Demo Courses: $e');
    }
    fetchingData = false;
  }
}
