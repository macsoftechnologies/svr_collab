import 'package:flutter/material.dart';
import 'package:svr/models/home_icons_models/online_classes_model.dart';

import '../../repositories/repositories.dart';
import '../../utils/snackbars_list.dart';

class OnlineClassesViewModel extends ChangeNotifier
{
  List<OnlineClassesModel> _onlineClasses = [];
  bool fetchingData = false;
  List<OnlineClassesModel> get onlineClassesInfo => _onlineClasses;

  Future<void> fetchOnlineClasses(subjectId, context) async {
    // print("idd");
    // print(subjectId);
    fetchingData = true;
    try {
      _onlineClasses = await Repositories().getOnlineClasses(subjectId);
      notifyListeners();
    } catch (e) {
      SnackBarsList().errorSnackBar(context, "Failed to Load Materials Due Technical Issue");
      throw Exception('Failed to load Materials: $e');
    }
    fetchingData = false;
  }
}