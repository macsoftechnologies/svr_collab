import 'package:flutter/material.dart';
import '../repositories/repositories.dart';

class LoginViewModel extends ChangeNotifier {
  Map<String, dynamic> _loginInfo = {};

  Map<String, dynamic> get loginData => _loginInfo;

  Future<void> fetchLoginData(emailMobile, password) async {
    try {
      _loginInfo = await Repositories().getLogin(emailMobile, password);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to Login Vailed: $e');
    }
  }
}
