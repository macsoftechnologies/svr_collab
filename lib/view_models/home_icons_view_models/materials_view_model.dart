import 'package:flutter/material.dart';
import '../../models/home_icons_models/materials_model.dart';
import '../../repositories/repositories.dart';
import '../../utils/snackbars_list.dart';

class MaterialsViewModel extends ChangeNotifier
{
  List<MaterialsModel> _materials = [];
  bool fetchingData = false;
  List<MaterialsModel> get materialsInfo => _materials;

  Future<void> fetchMaterials(subjectId, context) async {
    fetchingData = true;
    try {
      _materials = await Repositories().getMaterials(subjectId);
      notifyListeners();
    } catch (e) {
      SnackBarsList().errorSnackBar(context, "Failed to Load Materials Due Technical Issue");
      throw Exception('Failed to load Materials: $e');
    }
    fetchingData = false;
  }
}