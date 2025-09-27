import 'package:flutter/material.dart';
import 'package:svr/repositories/repositories.dart';

import '../../models/home_icons_models/profile_model.dart';
import '../../utils/snackbars_list.dart';

class ProfileViewModel extends ChangeNotifier
{
  ProfileModel? _profileData;
  bool fetchData = false;

  ProfileModel? get getProfileInfo => _profileData;

  Future<void> fetchProfileData(context)
  async {
    fetchData = true;
    try
        {
          _profileData = await Repositories().getProfile();
          notifyListeners();
        }catch (e)
    {
      SnackBarsList().errorSnackBar(context, "Failed to Load Materials Due Technical Issue");
      throw Exception('Failed to load Materials: $e');
    }
    fetchData = false;
  }
}