class RunLogic {
  void Function() notify;
  RunLogic({required this.notify});

  // Scaffold required variables
  late String goal;
  late String exercise;
  late double goalValueNum;
  late String goalValueString;

  // Function for setting the variables
  void setRunVariables(String goalVal, String exerciseVal,
      double goalValueNumVal, String goalValueStringVal) {
    goal = goalVal;
    exercise = exerciseVal;
    goalValueNum = goalValueNumVal;
    goalValueString = goalValueStringVal;

    // Reset distance to 0, so that run cancellation works properly when the
    // user starts one run after finishing another, rest handled by onRunStart()
    totalDistance = 0;
  }

  // Stopwatch related functions

  // Create and start stopwatch on run start, set up variables
  late Stopwatch stopwatch;
  double totalDistance = 0; // (in metres)
  int totalSteps = 0;
  late int totalAltGain; // (in mentres)
  bool isCheating = false;
  void onRunStart() {
    stopwatch = Stopwatch();
    stopwatch.start();
    totalDistance = 0; // Just in case
    totalAltGain = 0;
    totalSteps = 0;
    runOnce = true;
    // Make sure to disregard previous steps
    isCheating = false;
  }

  // Variable calculation on run finish
  double avgSpeed = 0;
  double timePerKm = 0;
  int stepsPerKm = 0;

  // Function to execute on run finish, finalises all the variables, runs as
  // async so that code can await its completion
  Future<void> onRunFinish() async {
    stopwatch.stop(); // -> total time
    avgSpeed = totalDistance / stopwatch.elapsedMilliseconds * 3600; //kph speed
    timePerKm = stopwatch.elapsedMilliseconds / totalDistance / 60; // in mins
    stepsPerKm = (totalSteps / (totalDistance / 1000)).round();
  }

  // Function to format time per km
  String formattedTimePerKm() {
    // Take out mins, the whole number part
    int mins = timePerKm.truncate();
    // Find the decimal part, multiply by 60 to covert to seconds
    String secs = ((timePerKm - timePerKm.truncate()) * 60).toStringAsFixed(0);
    return "$mins'$secs\"";
  }

  // Function to format stopwatch time
  String formatedTime() {
    // Get elapsed milliseconds
    int milliseconds = stopwatch.elapsedMilliseconds;

    // Calculate seconds
    var secs = milliseconds ~/ 1000;
    // Format hours, minutes, seconds and add leading 0's if required
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');

    return "$hours:$minutes:$seconds";
  }

  // Functions for adding data

  // Update total distance
  void updateDistance(double add) {
    totalDistance += add;
  }

  // Update total altitude
  void updateAlt(int add) {
    totalAltGain += add;
  }

  // Update step count
  bool runOnce = true;
  int prevSteps = 0;
  void updateSteps(int stepData) {
    if (runOnce) {
      prevSteps = stepData;
      runOnce = false;
      return;
    }
    totalSteps = stepData - prevSteps;
    return;
  }

  // Function to output cadence
  double calculateCadence() {
    double minutes = stopwatch.elapsedMilliseconds.toDouble() / 60000;
    double cadence = totalSteps / minutes;
    return cadence;
  }

  // Other functions

  // A function for checking whether the goal has been achieve
  bool checkGoal() {
    // If no goal return false
    if (goal == "None") return false;
    // Multiply goal value by 1000 since goal was in km and stored in m
    if (goal == "Distance") return (totalDistance > (goalValueNum * 1000));
    // Steps
    if (goal == "Steps") return (totalSteps > goalValueNum);
    // Time
    if (goal == "Time") {
      return (stopwatch.elapsedMilliseconds > goalValueNum * 60000);
    }
    // The code should not reach here, but just in case
    return false;
  }

  // Text to speech parser
  String goalSpeech() {
    if (goalValueNum == 1) {
      if (goal == "Distance") return "1 kilometre";
      // Steps
      if (goal == "Steps") return "1 step";
      // Time
      if (goal == "Time") return "1 minute";
    }

    // Since the value is a double, we need to remove decimal places to speak
    late String toSay;
    if (goal == "Distance") {
      toSay = goalValueNum.toStringAsFixed(2);
    } else {
      toSay = goalValueNum.toStringAsFixed(0);
    }

    // Return the required string
    // Distance
    if (goal == "Distance") return "$goalValueNum kilometres";
    // Steps
    if (goal == "Steps") return "$toSay steps";
    // Time
    if (goal == "Time") return "$toSay minutes";
    // Should never reach here, but for the sake of type safety
    return "";
  }
}
