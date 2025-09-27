import 'package:flutter/material.dart';

import '../models/subjects_model.dart';
import '../repositories/repositories.dart';

class SubjectsViewModel extends ChangeNotifier
{
  List<SubjectsModel> _subjects = [];
  bool fetchingData = false;
  List<SubjectsModel> get subjectsInfo => _subjects;

  Future<void> fetchSubjects(courseId) async {
    fetchingData = true;
    try {
      _subjects = await Repositories().getSubjects(courseId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load Demo Courses: $e');
    }
    fetchingData = false;
  }
}