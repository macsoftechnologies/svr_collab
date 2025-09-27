import 'package:flutter/material.dart';
import '../repositories/repositories.dart';

class RegisterViewModel extends ChangeNotifier {
  Map<String, dynamic> _registerInfo = {};

  Map<String, dynamic> get registerData => _registerInfo;

  Future<void> fetchRegisterData(name, email, Mobile, password, courseid) async {
    try {
      _registerInfo = await Repositories().getRegister(name, email, Mobile, password, courseid);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to Register: $e');
    }
  }
}
