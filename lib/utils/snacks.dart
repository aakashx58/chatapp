import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

showSuccessSnack(String message) {
  ScaffoldMessenger.of(AppSettings.navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: Colors.green,
    ),
  );
}

showErrorSnack(String message) {
  ScaffoldMessenger.of(AppSettings.navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: Colors.red,
    ),
  );
}
