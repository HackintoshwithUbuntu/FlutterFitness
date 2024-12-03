import 'package:flutter/material.dart';

// Function to show snackbar without referencing context
void showSnackbar(String text, ScaffoldMessengerState scaffoldState) {
  // Clear any previous snackbars
  scaffoldState.clearSnackBars();
  // Show new snackbar
  scaffoldState.showSnackBar(SnackBar(
    // This line seems to have no effect when an action is specified
    duration: const Duration(seconds: 3), 
    content: Text(text),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {}, // Do nothing except dismiss snackbar
    )
  ));
}
