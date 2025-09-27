import 'package:flutter/material.dart';
import 'package:svr/utils/global_keys.dart';
import '../../models/home_icons_models/courses_model.dart';
import '../../repositories/repositories.dart';

class StudyMaterialViewModel extends ChangeNotifier {

  List<CoursesModel> _my_Course = [];
  bool fetchingData = false;

  List<CoursesModel> get myCourse => _my_Course;

  Future<void> fetchCourse(String userid) async {
    fetchingData = true;
    try {
      _my_Course = await Repositories().getMycourse(userId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load  Courses: $e');
    }
    fetchingData = false;
  }
}