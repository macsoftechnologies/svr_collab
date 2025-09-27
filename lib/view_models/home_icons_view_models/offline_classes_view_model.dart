import 'package:flutter/cupertino.dart';
import 'package:svr/models/home_icons_models/offline_model.dart';
//import 'package:svr/models/home_icons_models/online_classes_model.dart';

import '../../repositories/repositories.dart';
import '../../utils/snackbars_list.dart';

class OfflineClassesViewModel extends ChangeNotifier
{
  List<OfflineModel> _offlineClasses = [];
  bool fetchingData = false;
  List<OfflineModel> get offlineClassesInfo => _offlineClasses;

  Future<void> fetchOfflineClasses(subjectId, context) async {
    fetchingData = true;
    try {
      _offlineClasses = await Repositories().getOfflineClasses(subjectId);
      notifyListeners();
    } catch (e) {
      SnackBarsList().errorSnackBar(context, "Failed to Load Materials Due Technical Issue");
      throw Exception('Failed to load Materials: $e');
    }
    fetchingData = false;
  }
}