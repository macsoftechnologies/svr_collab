import 'package:flutter/material.dart';
import 'colors.dart';

class SnackBarsList {
  successSnackBar(context, value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: successColor,
        content: Text(
          "$value",
          textAlign: TextAlign.center,
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  errorSnackBar(context, value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: errorColor,
        content: Text(
          "$value",
          textAlign: TextAlign.center,
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
