class AppLogic {
  void Function() notify;
  AppLogic({required this.onGoalChange, required this.notify});

  /////////////////
  /// HOME
  /////////////////

  // Goal related options
  String goal = "None";
  void Function() onGoalChange;

  void setGoal(String newGoal) {
    goal = newGoal;
    // print(newGoal);
    // This needs to be called again to help append correct unit
    if (newGoal != "None") {
      setGoalValue(goalValueString);
    } else {
      goalValueString = "None";
    }
    onGoalChange.call();
  }

  // Exercise type related options
  String exercise = 'Run';
  void setExercise(String type) {
    exercise = type;
    notify.call();
  }

  // Set goal value function
  double goalValueNum = 0;
  // Store it in a string as well for easy display, a double will add trailing 0s
  String goalValueString = "none";

  // Quick way to lookup value rather than using if statements
  static const Map converter = {
    "None": "",
    "Distance": "km",
    "Time": " minutes",
    "Steps": " steps"
  };
  static const Map unitConverter = {
    "None": "",
    "Distance": "km",
    "Time": " minute",
    "Steps": " step"
  };

  // Function to set new goal value
  void setGoalValue(String goalValue) {
    // print(goalValue);
    goalValueString = goalValue;

    // Remove trailing decimal place
    if (goalValueString.endsWith(".")) {
      goalValueString =
          goalValueString.substring(0, goalValueString.length - 1);
    }
    // In case of steps and time, decimal values are not appropriate
    if (((goal == "Time") || (goal == "Steps")) &&
        (goalValueString.contains("."))) {
      int index = goalValueString.indexOf(".");
      goalValueString = goalValueString.substring(0, index);
    }

    // Due to our extensive input control, we can assume this input is valid
    // however, the string may be empty
    if (double.tryParse(goalValue) == null) {
      goalValueNum = 0;
      goalValueString = "0";
    } else {
      goalValueNum = double.parse(goalValue);
    }

    // Append required text
    if (goalValueNum.toInt() == 1) {
      goalValueString += unitConverter[goal];
    } else {
      goalValueString += converter[goal];
    }
  }

  /////////////////
  /// LOGIN AND SIGNUP
  /////////////////

  // Login form storage
  String loginFormUsername = "";
  String loginFormPassword = "";

  // Signup form storage
  String signupFormUsername = "";
  String signupFormPassword = "";
  String signupFormPasswordConfirm = "";
  String signupFormFname = "";
  String signupFormLname = "";

  /////////////////
  /// NAV
  /////////////////

  // Variable to store current index
  int currentPageIndex = 0;

  // Set new index and tell ui
  void setNavIndex(int index) {
    // If navigating away from home, reset goal and run settings
    if (index != 0) {
      goal = "None";
      exercise = 'Run';
      goalValueNum = 0;
      goalValueString = "none";
    }

    currentPageIndex = index;
    notify.call();
  }

  // Check if an index is selected
  bool isIndexSelected(int index) {
    if (index == currentPageIndex) {
      return true;
    } else {
      return false;
    }
  }
}


/*
  // What to do when the user starts the run
  // Variables to store users final selection
  String? goalChosen;
  double? goalValueNumChosen;
  String? goalValueStringChosen;
  String? exerciseChosen;

  void onStartPress() {
    // Copy Variables
    goalChosen = goal;
    goalValueNumChosen = goalValueNum;
    goalValueStringChosen = goalValueString;
    exerciseChosen = exercise;
    // Reset Variables
    goal = "None";
    goalValueNum = 0;
    goalValueString = "none";
    exercise = 'Run';
  }
  */