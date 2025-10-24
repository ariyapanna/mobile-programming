import 'package:flutter/material.dart';
import '../main.dart'; 

void showGlobalSnackbar(String message, {bool isError = false}) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: isError ? Colors.red : Colors.green,
            duration: Duration(seconds: 3),
        ),
    );
}
