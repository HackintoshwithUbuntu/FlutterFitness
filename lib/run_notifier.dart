import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runfun/widgets/ui/show_snackbar.dart';

import 'package:runfun/run_logic.dart';
import 'package:runfun/main_networking.dart';

import 'package:geolocator/geolocator.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:pedometer/pedometer.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
//import 'package:geolocator_android/geolocator_android.dart';

class RunNotifier extends ChangeNotifier {
  // Class Setup
  late RunLogic _logicController;
  late AppNetworking _networkController;
  late GlobalKey<ScaffoldMessengerState> scaffoldKey;

  // Shared Preferences Instance - defined on app start, only used once in file
  late SharedPreferences prefs;

  RunNotifier({required this.scaffoldKey, required this.prefs}) {
    _logicController = RunLogic(notify: notify);
    _networkController = AppNetworking();
  }

  void notify() => notifyListeners();

  // Pass on starter variables
  void setRunVariables(String goalVal, String exerciseVal,
      double goalValueNumVal, String goalValueStringVal) {
    _logicController.setRunVariables(
        goalVal, exerciseVal, goalValueNumVal, goalValueStringVal);

    // Reset animation variables
    firstplayneeded = true;
    secondplayneeded = true;
    thirdplayneeded = true;
    fourthplayneeded = true;
  }

  // Workaround to play audio only once, since the animation seems to be
  // skipping some values ie. if(countdown.value == 0.01){do foo}, foo may
  // not happen - for the animation and audio countdown before run
  bool firstplayneeded = true;
  bool secondplayneeded = true;
  bool thirdplayneeded = true;
  bool fourthplayneeded = true;

  // Function to get the goal text
  String get goalValueString => _logicController.goalValueString;

  // Location settings to use with geolocator
  final AndroidSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.best,
      // Set location fetch duration
      intervalDuration: const Duration(seconds: 2),
      // While MSL altitude is generally considered better, I have encountered
      // issues with its implementation on android
      useMSLAltitude: false,
      // Ignore very small changes
      distanceFilter: 1,
      // The new implementation was not giving any changing altitude
      // measurements on my phone
      forceLocationManager: false,
      // Set foreground notification config to keep the app alive
      // when going to the background
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
            "FlutterFit will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
        notificationIcon:
            AndroidResource(name: 'ic_stat_notif', defType: 'mipmap'),
      ));

  // Function to start the run timer and location stream

  // Stream storage
  // Variable to access location stream
  late StreamSubscription<Position> positionStream;
  // Variable to access pedometer (step count) stream
  late StreamSubscription<StepCount> pedometerStream;
  // Value storage
  List<double> lats = [];
  List<double> longs = [];
  List<int> alts = [];
  List<int> times = [];

  // Actual function
  void onRunStart() {
    // Reset notifier storage variables
    goalAchieved = false;
    lats = [];
    longs = [];
    alts = [];
    times = [];

    // Start stopwatch and set tracking variables
    _logicController.onRunStart();

    // Set pedometer
    pedometerStream = Pedometer.stepCountStream.listen((event) {
      _logicController.updateSteps(event.steps);
    });

    // Stream for tracking location
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      //print(position == null
      //? 'Unknown'
      //: '${position.latitude.toString()}, ${position.longitude.toString()}, ${position.altitude.toString()}, ${position.timestamp.toString()}, ${position.accuracy.toString()}');

      // Round the altitude
      int tempAlt = (position!.altitude).floor();

      // Filter out erroneous measurements
      if (!position.isMocked && position.accuracy <= 30.0) {
        // Only calculate differences when we have two values
        if (alts.length > 1) {
          // Calculate difference
          int altDif = tempAlt - alts.last;
          // If user climbed add to counter
          if (altDif > 0) _logicController.updateAlt(altDif);

          // Calculate distance travelled
          double distanceInMeters = Geolocator.distanceBetween(
              lats.last, longs.last, position.latitude, position.longitude);
          // Add to counter
          _logicController.updateDistance(distanceInMeters);
        }

        // Append data to list storage
        lats.add(position.latitude);
        longs.add(position.longitude);
        alts.add(tempAlt);
        times.add(position.timestamp!.millisecondsSinceEpoch);
      }
    });
  }

  // Scaffold key state that is used to send SnackBars
  late final ScaffoldMessengerState scaffoldState = scaffoldKey.currentState!;

  // Compute a string which has the start and end time in human readable format
  String startEndTimeStringCalc(DateTime start, DateTime end) {
    // Set formatter
    final DateFormat formatter = DateFormat('MMM d, yyyy h:mm a');
    // Format strings
    final String startString = formatter.format(start);
    final String endString = formatter.format(end);
    // Combine and return
    return "$startString - $endString";
  }

  // Code to execute when the run finishes
  void onRunFinish() async {
    // Stop listening for updates
    await positionStream.cancel();
    await pedometerStream.cancel();

    // Calculate final variables
    await _logicController.onRunFinish();
    // Reversed variable names, becuase startTime is used below
    DateTime timeStart = DateTime.fromMillisecondsSinceEpoch(times.first);
    DateTime timeEnd = DateTime.fromMillisecondsSinceEpoch(times.last);
    startEndTimeString = startEndTimeStringCalc(timeStart, timeEnd);
    // Calculate whether cheating
    if (_logicController.avgSpeed > 44.72) {
      // The user can allegedly run at Usain Bolt max speed for extended period
      _logicController.isCheating = true;
    } else if (_logicController.totalSteps != 0 &&
        _logicController.stepsPerKm < 200) {
      // Don't false positive users with no pedometer
      // The user allegedly has a stride length of 5 metres
      _logicController.isCheating = true;
    }

    // Tell the UI when everything has been calculated
    notify();

    // Collate all data in a dictionary
    Map<String, dynamic> store = {};
    String uname = prefs.getString("username")!;
    // Get file name
    int startTime = times[0];

    store['username'] = uname;
    store['datetime'] = times;
    store['start'] = startTime;
    store['lats'] = lats;
    store['longs'] = longs;
    store['alts'] = alts;
    store['timeString'] = timeString;
    store['totalDistance'] =
        (_logicController.totalDistance / 1000).toStringAsFixed(2);
    store['totalAltGain'] = totalAltGain;
    store['totalSteps'] = totalSteps;
    store['cadence'] = cadence;
    store['avgSpeed'] = avgSpeed;
    store['timePerKm'] = timePerKm;
    store['stepsPerKm'] = stepsPerKm;
    store['exercise'] = _logicController.exercise;
    store['startEndTimeString'] = startEndTimeString;
    store["isCheating"] = _logicController.isCheating;

    String jsonString = json.encode(store);

    // Store data locally

    final Directory appDocDir = await getApplicationDocumentsDirectory();

    // Make sure directory exists
    final String path = '${appDocDir.path}/$uname/';
    final userExists = await Directory(path).exists();
    if (!userExists) await Directory('${appDocDir.path}/$uname/').create();

    final File file = File('${appDocDir.path}/$uname/$startTime.json');
    await file.writeAsString(jsonString);

    List<String> phrases = ["Nice Work!", "Great job!", "Good job!"];
    var random = Random();
    var chosen = random.nextInt(phrases.length);

    // Send data to cloud
    bool dataSent = await _networkController.sendRundata(jsonString);
    if (dataSent) {
      showSnackbar(
          "${phrases[chosen]} Data synced with server successfully", scaffoldState);
    } else {
      showSnackbar(
          "Data failed to sync, will sync when connectivity is restored",
          scaffoldState);
    }
  }

  void onPrematureRunFinish() async {
    try {
      // Stop listening for updates
      await positionStream.cancel();
      await pedometerStream.cancel();
    } catch (e) {
      return;
    }
  }

  // Function to check whether goal achieved and react if so
  // This function is called every 2 seconds from the DuringRun widget
  bool goalAchieved = false;
  TextToSpeech tts = TextToSpeech();
  var volumeController = VolumeController();
  void checkGoal() {
    // If the goal has already been hit do nothing
    if (goalAchieved) return;

    //volumeController.setVolume(0.8);
    if (_logicController.checkGoal()) {
      volumeController.setVolume(0.8);
      goalAchieved = true;
      HapticFeedback.heavyImpact();
      String goalText = _logicController.goalSpeech();
      tts.speak("Your goal of $goalText has been achieved");
    }
  }

  // Function to get the time as a formatted string
  String get timeString => _logicController.formatedTime();
  // Function to get distance run as a string
  String get totalDistance =>
      (_logicController.totalDistance / 1000).toStringAsFixed(2);
  // Function to get alitude gain as a string
  String get totalAltGain => _logicController.totalAltGain.toString();
  // Function to get steps taken as a string
  String get totalSteps => _logicController.totalSteps.toString();
  // Function to get cadence as a string
  String get cadence => _logicController.calculateCadence().toStringAsFixed(0);
  // Function to get average speed as a string
  String get avgSpeed => _logicController.avgSpeed.toStringAsFixed(2);
  // Function to get time per km in minutes seconds format as a string
  String get timePerKm => _logicController.formattedTimePerKm();
  // Function to get steps per km as a string
  String get stepsPerKm => _logicController.stepsPerKm.toString();
  // String for start and end times, gets edited later
  String startEndTimeString = "Date";
  // String for the exercise type
  String get exerciseType => _logicController.exercise;
  // String for checking whether the user cheated
  bool get isCheating => _logicController.isCheating;
}
