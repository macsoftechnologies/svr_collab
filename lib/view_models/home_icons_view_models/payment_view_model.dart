import 'package:flutter/material.dart';

import '../../repositories/repositories.dart';




class PaymentViewModel extends ChangeNotifier {
  Map<String, dynamic> _PaymentInfo = {};

  Map<String, dynamic> get paymentData => _PaymentInfo;

  Future<void> confirmPaymentData(userid,courseid,amount,transcationid,taxid) async {
    try {
      _PaymentInfo = await Repositories().confirmPayment(userid,courseid,amount,transcationid,taxid);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to pay: $e');
    }
  }
}