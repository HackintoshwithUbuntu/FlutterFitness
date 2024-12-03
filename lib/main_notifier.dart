import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:runfun/widgets/ui/show_snackbar.dart';

import 'package:runfun/views/run_views/run_view.dart';
import 'package:runfun/views/login_views/login_view.dart';
import 'package:runfun/views/login_views/signup_view.dart';

import 'package:runfun/main_logic.dart';
import 'package:runfun/main_networking.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

// The job of this file is to serve as a bridge between the Flutter app
// and the pure dart class, it primarily forwards values to be calculated
// and also notifies the code of changes so it can update widgets accordingly

// The advantage of this seperation is that Flutter functions can be run within
// this file and most mathematical logic can be offloaded to the pure dart class,
// which makes things much easier when testing

class AppNotifier extends ChangeNotifier {
  // Class Setup
  late AppLogic _logicController;
  late AppNetworking _networkController;
  late GlobalKey<ScaffoldMessengerState> scaffoldKey;
  late GlobalKey<NavigatorState> navigatorKey;

  // Shared Preferences Instance - defined on app start
  late SharedPreferences prefs;

  AppNotifier(
      {required this.scaffoldKey,
      required this.navigatorKey,
      required this.prefs}) {
    _logicController = AppLogic(onGoalChange: onGoalChange, notify: notify);
    _networkController = AppNetworking();
  }

  void notify() => notifyListeners();

  // Function to clear all snackbars
  void clearSnackbars() {
    scaffoldState.clearSnackBars();
  }

  // Function to check for errors from networking code, automatically shows
  // a message if there is an error
  // Technically it doesnt make a difference if the input variables are swapped
  bool isError(var expected, var received) {
    if (expected == received) {
      showSnackbar(
          "There was an error, check your internet connection", scaffoldState);
      return true;
    }
    return false;
  }

  // Code to run on app startup, this functino was previously more substantial
  Future<void> onAppStart() async {
    await trackLocation();
  }

  /////////////////
  /// HOME
  /////////////////

  // Goal related options
  // Goal storage variable
  String get goal => _logicController.goal;
  // Set a new goal
  // Ideally this would be a set, but we need to call notify listeners
  // so this must be a function
  void setGoal(String goal) => _logicController.setGoal(goal);
  // Function to notify code of goal change
  void onGoalChange() => notifyListeners();
  // Set a new goal value
  void setGoalValue(String goalValue) =>
      _logicController.setGoalValue(goalValue);

  double get goalValueNum => _logicController.goalValueNum;
  String get goalValueString => _logicController.goalValueString;

  // Exercise type related options
  String get exercise => _logicController.exercise;
  void setExercise(String type) {
    _logicController.setExercise(type);
    // Reset the goal
    setGoal("None");
    setGoalValue("");
  }

  // Check login status
  Future<bool> checkLogin() async {
    // Try reading login status, if doesnt exist, returns null
    final bool? loginStatus = prefs.getBool('loginStatus');

    // If the user is not logged in, ask them to sign in
    if (loginStatus == true) {
      return true;
    } else {
      // Reset tracker variables
      loginFormPassword = '';
      loginFormUsername = '';

      // Push login page with animation
      navigatorKey.currentState!.push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Login(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ));

      return false;
    }
  }

  // On start run button press
  Future<VoidCallback?> onStartPress(BuildContext context) async {
    // If the user was not logged in, dont start run
    bool loginStatus = await checkLogin();
    if (!loginStatus) return null;

    // Play the button press sound
    final player = AudioPlayer();
    player.play(AssetSource('sounds/customDing.mp3'));

    // Ensure the BuildContext hasnt changed and push new page
    if (context.mounted) {
      //_logicController.onStartPress();
      Navigator.push(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => const RunView()),
      );
    }
    return null;
  }

  /////////////////
  /// LOGIN AND SIGNUP
  /////////////////

  // Set parameters from login form
  set loginFormUsername(data) => _logicController.loginFormUsername = data;
  set loginFormPassword(data) => _logicController.loginFormPassword = data;

  // Set parameters from signup form
  set signupFormUsername(data) => _logicController.signupFormUsername = data;
  set signupFormPassword(data) => _logicController.signupFormPassword = data;
  set signupFormPasswordConfirm(data) =>
      _logicController.signupFormPasswordConfirm = data;
  set signupFormFname(data) => _logicController.signupFormFname = data;
  set signupFormLname(data) => _logicController.signupFormLname = data;

  // Scaffold messenger state used for sending snackbars
  late final ScaffoldMessengerState scaffoldState = scaffoldKey.currentState!;

  void pushSignupPage(BuildContext context) {
    if (context.mounted) {
      // Reset tracking variables
      signupFormUsername = '';
      signupFormPassword = '';
      signupFormPasswordConfirm = '';
      signupFormFname = '';
      signupFormLname = '';

      // Push new page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Signup()),
      );
    }
  }

  // Attempt a signup and update UI accordingly
  Future<VoidCallback?> onSignupPress(BuildContext context) async {
    // Check that password and confirrm password fields match
    if ((_logicController.signupFormPassword !=
        _logicController.signupFormPasswordConfirm)) {
      showSnackbar(
          "Password and confirm password fields don't match", scaffoldState);
      return null;
    }

    // Wait for the request to run
    bool signupSuccessful = await _networkController.attemptSignup(
        _logicController.signupFormUsername,
        _logicController.signupFormPassword,
        _logicController.signupFormFname,
        _logicController.signupFormLname);

    // If successful redirect user to login and give confirmation
    if (signupSuccessful && context.mounted) {
      showSnackbar("Great! You can sign in now.", scaffoldState);
      Navigator.of(context).pop();
      // Else tell them to try again
    } else {
      showSnackbar('Signup failed, username is already taken', scaffoldState);
    }
    return null;
  }

  // Attempt a login and update UI accordingly
  Future<VoidCallback?> onLoginPress(BuildContext context) async {
    // Attempt to login
    List loginData = await _networkController.attemptLogin(
        _logicController.loginFormUsername, _logicController.loginFormPassword);

    // Extract whether successful or not
    bool loginSuccessful = loginData[0];

    // If successful tell user and remove login screen
    if (loginSuccessful && context.mounted) {
      showSnackbar('Login Successful!', scaffoldState);
      Navigator.of(context).pop();
      // Else tell them to troubleshoot and try again
    } else {
      showSnackbar(
          'Login failed, check your credentials and internet connection',
          scaffoldState);
      return null;
    }

    // Store credentials for later access
    await prefs.setString('username', _logicController.loginFormUsername);
    await prefs.setString('fname', loginData[1]);
    await prefs.setString('lname', loginData[2]);
    await prefs.setBool('sendLocation', loginData[3]);
    await prefs.setString('country', loginData[4]);
    await prefs.setBool('loginStatus', true);

    // Start sending periodic notification updates if required
    await trackLocation();

    return null;
  }

  /////////////////
  /// FRIENDS AND LEADERBOARDS
  /////////////////

  List<dynamic> worldDistance = [];
  List<dynamic> countryDistance = [];
  List<dynamic> friendsDistance = [];
  List<dynamic> worldTime = [];
  List<dynamic> countryTime = [];
  List<dynamic> friendsTime = [];
  List<dynamic> worldSteps = [];
  List<dynamic> countrySteps = [];
  List<dynamic> friendsSteps = [];

  // Function to get leaderbords from server and update local data
  Future<String> updateLeaderboards() async {
    String uname = prefs.getString("username")!;

    // Get data from server
    String serverData = await _networkController.getLeaderboards(uname);
    // The future value is not used so we can return anything
    if (isError("Fail", serverData)) return "Complete";

    // Populate data
    var data = jsonDecode(serverData);
    worldDistance = List<dynamic>.from(data["worldDistance"]);
    countryDistance = List<dynamic>.from(data["countryDistance"]);
    friendsDistance = List<dynamic>.from(data["friendsDistance"]);
    worldTime = List<dynamic>.from(data["worldTime"]);
    countryTime = List<dynamic>.from(data["countryTime"]);
    friendsTime = List<dynamic>.from(data["friendsTime"]);
    worldSteps = List<dynamic>.from(data["worldSteps"]);
    countrySteps = List<dynamic>.from(data["countrySteps"]);
    friendsSteps = List<dynamic>.from(data["friendsSteps"]);

    // Return something to make futurebuilder happy
    return "Complete";
  }

  // Variable to track whether user in UI is a friend or not, this is only
  // accessed after the below future compeletes so should always yield the
  // correct value
  bool friendStatus = false;

  // Function to get the info of a requested user
  Future<List<dynamic>> getUserInfo(String requested) async {
    String uname = prefs.getString("username")!;
    List<dynamic> userData =
        await _networkController.getUserInfo(uname, requested);

    // Pop the loading screen
    if (isError(false, userData[0])) {
      navigatorKey.currentState!.pop();
      return [];
    }

    friendStatus = userData[1];
    return userData;
  }

  // Function to friend a user
  Future<bool> friendUser(String friend) async {
    String uname = prefs.getString("username")!;

    // Ask to friend / unfriend user by sending opposite of current state
    bool? changeStatus =
        await _networkController.friendUser(uname, friend, !friendStatus);

    if (isError(null, changeStatus)) return false;

    // Change friend status if required
    if (changeStatus!) {
      friendStatus = !friendStatus;
      showSnackbar("Success!", scaffoldState);
    }
    // Tell UI to update
    notifyListeners();
    return changeStatus;
  }

  /////////////////
  /// NEARBY
  /////////////////

  // Start automatic location updater
  late StreamSubscription<Position> locationStream;

  // Variables for starting camera position for the nearby screen
  double? lastLat;
  double? lastLong;

  Future<void> updateLastLocation() async {
    // Populate lastlat and lastlong
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    lastLat = currentPosition.latitude;
    lastLong = currentPosition.longitude;
  }

  Timer? locationSendTimer;

  // Function to periodically update nearby location on server
  Future<void> trackLocation() async {
    // Try reading login status, if doesnt exist, returns null
    final bool? loginStatus = prefs.getBool('loginStatus');
    if (loginStatus != true) return;

    // Assume logged in and read other preferences
    final bool? sendLocation = prefs.getBool('sendLocation');
    String uname = prefs.getString("username")!;

    await updateLastLocation();
    // Send initial data to server, so we dont have to wait 1 minute
    if (sendLocation == true) {
      await _networkController.sendLocation(uname, lastLat!, lastLong!);
    }

    // Code that is invoked continuously
    if (sendLocation!) {
      locationSendTimer =
          Timer.periodic(const Duration(minutes: 1), (timer) async {
        await updateLastLocation();
        await _networkController.sendLocation(uname, lastLat!, lastLong!);
      });
    }

    return;
  }

  // Function which waits for a location to be in the program
  Future<double> getNonNullLatLong() async {
    while (lastLong == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return lastLong!;
  }

  // Storage for data about nearby users
  List<String> nearbyUnames = [];
  List<String> nearbyNames = [];
  List<double> nearbyLats = [];
  List<double> nearbyLongs = [];
  List<int> nearbyDistances = [];
  List<int> nearbyUpdated = [];

  Future<void> updateNearby() async {
    String uname = prefs.getString("username")!;

    // Update last location to ensure the variables have data and that the
    // query uses the latest location

    await updateLastLocation();
    var serverdata =
        await _networkController.getLocations(uname, lastLat!, lastLong!);

    if (isError("Fail", serverdata)) return;

    // Populate data, using explicit types
    var data = jsonDecode(serverdata);
    nearbyUnames = List<String>.from(data[0]);
    nearbyNames = List<String>.from(data[1]);
    nearbyLats = List<double>.from(data[2]);
    nearbyLongs = List<double>.from(data[3]);
    nearbyDistances = List<int>.from(data[4]);
    nearbyUpdated = List<int>.from(data[5]);
    return;
  }

  // Variables for tracking the card info on the nearby page
  bool showNearbyCard = false;
  String shownNearbyUname = "";
  String shownNearbyName = "";
  String shownNearbyDistance = "";
  String shownNearbyUpdate = "";

  // One function for all updates
  void updateNearbyShown(String username, bool tapped) {
    // In case tapped, update username shown, else leave as is
    if (tapped) {
      showNearbyCard = true;
      shownNearbyUname = username;
    }
    // Find index of username
    int index = nearbyUnames.indexOf(shownNearbyUname);
    // Take care of case where username doesnt exist
    // This also takes care of the case where a selected user exceeds the 5 min
    // recent limit
    if (index == -1) {
      showNearbyCard = false;
      return;
    }

    // Update variables if required
    shownNearbyName = nearbyNames[index];
    shownNearbyDistance = nearbyDistances[index].toString();
    shownNearbyUpdate = nearbyUpdated[index].toString();
    notify();
    return;
  }

  /////////////////
  /// HISTORY
  /////////////////

  // Set initial values, the UI assumes these until data comes in
  bool emptyHistory = true;
  bool loading = true;
  Set<Map<String, String>> historyRuns = {};

  // Function to run on history page load
  Future<void> historyPageLoad(
      GlobalKey<RefreshIndicatorState> historyRefreshkey) async {
    // Show loader
    historyRefreshkey.currentState?.show();

    String uname = prefs.getString("username")!;

    // Fetch local data

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String path = '${appDocDir.path}/$uname/';
    // Make sure directory exists
    final userExists = await Directory(path).exists();
    if (!userExists) await Directory('${appDocDir.path}/$uname/').create();
    // Get contents of directory
    final List<FileSystemEntity> entities =
        await Directory(path).list().toList();
    // Get only the files
    final Iterable<File> files = entities.whereType<File>();
    // Make a list of the titles
    List<String> titleList = [];
    for (final i in files) {
      titleList.add(i.uri.pathSegments.last);
    }

    // Check cache status from server
    Map<String, dynamic> historyStatus =
        await _networkController.fetchHistoryStatus(uname, titleList);

    // If error, use cached data
    if (historyStatus["error"]) {
      return await propagateHistory(
          historyStatus["error"], Directory('${appDocDir.path}/$uname/'));
    }

    // Send runs requested
    for (final i in historyStatus["serverneed"]) {
      // Get file from storage, noting that .json is already part of name
      final File file = File('${appDocDir.path}/$uname/$i');
      // Send file
      final String jsonSend = await file.readAsString();
      final bool sent = await _networkController.sendRundata(jsonSend);
      if (!sent) {
        showSnackbar("Error sending data, will sync later", scaffoldState);
      }
    }

    // Get runs not already on device
    for (final i in historyStatus["clientneed"]) {
      // Get file date from server, noting that .json is already part of name
      String rundata = await _networkController.getRundata(uname, i);
      // Write rundata to file
      final File file = File('${appDocDir.path}/$uname/$i');
      await file.writeAsString(rundata);
    }

    showSnackbar('Data synced with server', scaffoldState);
    return propagateHistory(false, Directory('${appDocDir.path}/$uname/'));
  }

  // Function to load in the run history based on saved files
  Future<void> propagateHistory(bool error, Directory storage) async {
    clearSnackbars();
    if (error) showSnackbar('Sync failed, using cached data', scaffoldState);
    // Get contents of directory
    final List<FileSystemEntity> entities = await storage.list().toList();
    // Make a custom sort function since Files cant be sorted by default
    // Wrap in a negative as we are sorting with latest first
    entities.sort((a, b) => -(a.uri.toString().compareTo(b.uri.toString())));
    // Get only the files
    final Iterable<File> files = entities.whereType<File>();

    // Reset tracking variable
    historyRuns = {};
    // Fill run data storage variable
    final DateFormat formatter = DateFormat('MMM d, yyyy h:mm a');
    for (final i in files) {
      final data = await jsonDecode(await i.readAsString());
      Map<String, String> temp = {};
      temp["type"] = data["exercise"];
      temp["steps"] = data["totalSteps"];
      temp["time"] = data["timeString"];
      temp["date"] =
          formatter.format(DateTime.fromMillisecondsSinceEpoch(data["start"]));
      temp["distance"] = data["totalDistance"];
      temp["fileName"] = i.uri.pathSegments.last;
      historyRuns.add(temp);
    }

    // If there are runs, tell the UI to not show no runs text
    if (files.isNotEmpty) emptyHistory = false;

    // Tell the UI to stop loading
    loading = false;
    notify();
  }

  // Function which reads fun data from file and puts it in dart types
  Future<Map<String, dynamic>> getRundataFromFile(String fileName) async {
    String uname = prefs.getString("username")!;
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File file = File('${appDocDir.path}/$uname/$fileName');

    final String data = await file.readAsString();

    var runData = jsonDecode(data);

    // Unfortunatly Flutter typing necessitates this monster
    // Manually asign types for data
    Map<String, dynamic> returnData = {};
    returnData['datetime'] = runData["datetime"];
    returnData['start'] = runData["start"];
    returnData["lats"] = List<double>.from(runData["lats"]);
    returnData["longs"] = List<double>.from(runData["longs"]);
    returnData["alts"] = List<int>.from(runData["alts"]);
    returnData['timeString'] = runData["timeString"];
    returnData['totalDistance'] = runData["totalDistance"];
    returnData['totalAltGain'] = runData["totalAltGain"];
    returnData['totalSteps'] = runData["totalSteps"];
    returnData['cadence'] = runData["cadence"];
    returnData['avgSpeed'] = runData["avgSpeed"];
    returnData['timePerKm'] = runData["timePerKm"];
    returnData['stepsPerKm'] = runData["stepsPerKm"];
    returnData['exerciseType'] = runData["exercise"];
    returnData['startEndTimeString'] = runData["startEndTimeString"];
    returnData['isCheating'] = runData["isCheating"];

    return returnData;
  }

  /////////////////
  /// SETTINGS
  /////////////////

  // Function to adjust status for periodic updates to nearby location server
  Future<bool> stopTracking() async {
    bool? sendLocation = prefs.getBool('sendLocation');
    final String uname = prefs.getString("username")!;

    // Both null check and use opposite of sendlocation value since the user
    // is changing it
    bool locationChanged =
        await _networkController.changeLocationSetting(uname, !sendLocation!);

    if (isError(false, locationChanged)) return sendLocation;

    // Set send location to not send location
    await prefs.setBool('sendLocation', !sendLocation);
    sendLocation = !sendLocation;

    // Update the timer as required
    if (sendLocation) {
      await updateLastLocation();
      await _networkController.sendLocation(uname, lastLat!, lastLong!);
      locationSendTimer =
          Timer.periodic(const Duration(minutes: 1), (timer) async {
        await updateLastLocation();
        await _networkController.sendLocation(uname, lastLat!, lastLong!);
      });
    } else {
      locationSendTimer?.cancel();
    }

    notifyListeners();
    return sendLocation;
  }

  String get settingsUsername => prefs.getString("username")!;
  String get settingsFname => prefs.getString("fname")!;
  String get settingsLname => prefs.getString("lname")!;
  bool get settingsLocation => prefs.getBool("sendLocation")!;
  bool get settingsCountry => prefs.getBool("country")!;

  // Function to change a users name and update relevant values
  Future<void> changeName(String newName, bool isFname) async {
    final String uname = prefs.getString("username")!;
    late bool nameChanged;

    // Validate input
    if (newName == "") {
      showSnackbar("Cannot have empty name", scaffoldState);
      navigatorKey.currentState!.pop();
      return;
    }

    // If updating first name update first, else update last name
    if (isFname) {
      nameChanged = await _networkController.changeFname(uname, newName);
    } else {
      nameChanged = await _networkController.changeLname(uname, newName);
    }

    if (isError(false, nameChanged)) {
      navigatorKey.currentState!.pop();
      return;
    }

    // Update shared preferences
    if (isFname) {
      await prefs.setString("fname", newName);
    } else {
      await prefs.setString("lname", newName);
    }

    // Update UI elements
    showSnackbar("${isFname ? 'First Name' : 'Last Name'} changed successfully",
        scaffoldState);
    navigatorKey.currentState!.pop();
  }

  // Function to update a users country
  Future<void> changeCountry(String newCountry) async {
    final String uname = prefs.getString("username")!;

    final bool countryChanged =
        await _networkController.changeCountry(uname, newCountry);

    if (isError(false, countryChanged)) {
      navigatorKey.currentState!.pop();
      return;
    }

    showSnackbar("Country changed successfully", scaffoldState);
    navigatorKey.currentState!.pop();
  }

  // Function to logout os user account
  Future<void> settingsLogout() async {
    // Navigate to home
    setNavIndex(0);
    // Remove shared prefs with userdata
    await prefs.remove('username');
    await prefs.remove('fname');
    await prefs.remove('lname');
    await prefs.remove('sendLocation');
    await prefs.remove('country');
    await prefs.remove('loginStatus');

    // Tell the user
    showSnackbar("Logged out successfully", scaffoldState);
  }

  // Function to reset the users run data on server
  Future<void> resetUserData() async {
    final String uname = prefs.getString("username")!;

    bool dataGone = await _networkController.resetData(uname);
    if (isError(false, dataGone)) return;

    // Delete data from user device
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String path = '${appDocDir.path}/$uname/';
    final userExists = await Directory(path).exists();
    if (userExists) await Directory('${appDocDir.path}/$uname/').delete(recursive: true);

    // Pop navigator so that dialogue is dismissed
    navigatorKey.currentState!.pop();
    showSnackbar("Data deleted from server successfullly", scaffoldState);
  }

  // Getter function to fetch latest theme data value
  // This function takes into account that the original shared prefs will not
  // include a value and handles that case
  bool get isDarkMode {
    bool? darkPref = prefs.getBool('isDarkMode');
    // Return true or false depending on pref value
    if (darkPref == true) {
      return true;
    } else {
      // This includes both null and false cases, there is no need to actually
      // set a value until the variable stores something meaningful
      return false;
    }
  }

  // Getter function to get the type of the theme mode of the app
  ThemeMode get appTheme {
    // Return required theme mode
    if (isDarkMode == true) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  // Function to set dark mode
  Future<void> setDarkMode(bool newValue) async {
    await prefs.setBool("isDarkMode", newValue);
    notifyListeners();
  }

  /////////////////
  /// NAV
  /////////////////

  // Return current index value from other file
  int get currentPageIndex => _logicController.currentPageIndex;

  // Set new index
  void setNavIndex(int index) async {
    // If the user was not logged in, dont change page and ask for login
    bool loginStatus = await checkLogin();
    if (!loginStatus) return;
    _logicController.setNavIndex(index);

    // Execute code to cleanup nearby page
    if (index != 3) leftNearby();
  }

  // Fix glitch if leave nearby page while the card is open
  void leftNearby() {
    showNearbyCard = false;
    shownNearbyUname = "";
    shownNearbyName = "";
    shownNearbyDistance = "";
    shownNearbyUpdate = "";
    notify();
  }

  // Check if index selected
  bool isIndexSelected(int index) => _logicController.isIndexSelected(index);
}
