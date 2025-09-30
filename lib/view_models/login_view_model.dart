import 'package:flutter/material.dart';
import '../repositories/repositories.dart';

class LoginViewModel extends ChangeNotifier {
  Map<String, dynamic> loginData = {};

  Future<void> fetchLoginData(String emailMobile, String password, String deviceId) async {
    try {
      loginData = await Repositories().getLogin(emailMobile, password, deviceId);
      notifyListeners();
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}

