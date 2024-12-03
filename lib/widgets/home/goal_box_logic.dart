class GoalBoxLogic {
  String goalText(String goal) {
    late String goalText;
    // Based on goal type select the unit dispayed
    switch (goal) {
      case "None":
        goalText = "";
        break;
      case "Distance":
        goalText = "km";
        break;
      case "Time":
        goalText = "minutes";
        break;
      case "Steps":
        goalText = "steps";
        break;
    }
    return goalText;
  }

  // Function to check whether to display input box
  bool goalEnabled(String goal) {
    if (goal == "None") {
      return false;
    } else {
      return true;
    }
  }

  // If distance allow 2 decimal places, else do not
  RegExp goalRegex(String goal) {
    if (goal == "Distance") return RegExp(r"^\d+\.?\d{0,2}");
    return RegExp(r"^[1-9]\d*");
  }
}
