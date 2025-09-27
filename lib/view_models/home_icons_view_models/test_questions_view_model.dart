import 'package:flutter/material.dart';
import 'package:svr/models/home_icons_models/test_questions_model.dart';
import '../../repositories/repositories.dart';
import '../../utils/snackbars_list.dart';

class TestQuestionsViewModel extends ChangeNotifier
{
  List<TestQuestionsModel> _testQuestions = [];
  bool fetchingData = false;
  List<TestQuestionsModel> get testQuestionsInfo => _testQuestions;

  Future<void> fetchTestQuestions(context) async {
    fetchingData = true;
    try {
      _testQuestions = await Repositories().getTestQuestions();
      notifyListeners();
    } catch (e) {
      SnackBarsList().errorSnackBar(context, "Failed to Load Tests Due Technical Issue");
      throw Exception('Failed to load Tests: $e');
    }
    fetchingData = false;
  }
}