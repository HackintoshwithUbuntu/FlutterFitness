import 'package:flutter/material.dart';

import 'package:runfun/pageswitcher.dart';
import 'package:runfun/widgets/home/pulsing_button.dart';
import 'package:runfun/widgets/home/goal_and_type_container.dart';

import 'package:runfun/notifications.dart';

import 'package:runfun/run_notifier.dart';
import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// Shared prefs instance to pass through
late SharedPreferences prefs;

Future main() async {
  // Tell Google Fonts to use the local copy and not fetch fron internet
  GoogleFonts.config.allowRuntimeFetching = false;

  // Initialise shared prefs here, this was previously handled much more cleanly
  // within the notifier.onappstart() function but when implementing dark mode
  // it had to be moved here as this is pretty much the only place where I can 
  // run async code that will wait for the instance and also be accessible by 
  // the MaterialApp return method
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await NotificationService().initNotification();

  // Set time of notification, noting that the past is not a valid time
  DateTime now = DateTime.now();
  DateTime todayNotifTime = DateTime(now.year, now.month, now.day, 16, 00);
  DateTime tomorrowNotifTime = DateTime(now.year, now.month, now.day+1, 16, 00);
  late DateTime chosenNotifTime;
  // If now before todays notif time, set today, else set tomorrow
  if (now.compareTo(todayNotifTime) < 0) {
    chosenNotifTime = todayNotifTime;
  } else {
    chosenNotifTime = tomorrowNotifTime;
  }
  // Calculate time remaining until need to send notification
  Duration notifTimeRemaining = chosenNotifTime.difference(now);

  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "NotifDaily",
    "NotifSender",
    // Replace the old task to help realign with correct time if needed
    existingWorkPolicy: ExistingWorkPolicy.replace,
    initialDelay: notifTimeRemaining,
    frequency: const Duration(hours: 24),
  );

  // Start the notification scheduler
  //await scheduleNotifs();

  runApp(const MyAppStarter());
}

class MyAppStarter extends StatelessWidget {
  const MyAppStarter({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    // Crete a reference variable for the notification package
    //final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        //FlutterLocalNotificationsPlugin();

    // Get permissions and other app setup tasks
    Future<void> onStartFuture() async {
      // Get location permission if not already allowed
      // Await current status
      final GeolocatorPlatform geolocatorAndroid = GeolocatorPlatform.instance;
      LocationPermission locPerm = await geolocatorAndroid.checkPermission();
      // If denied then ask user to allow
      if (locPerm == LocationPermission.denied) {
        locPerm = await geolocatorAndroid.requestPermission();
      }

      // Request Activity permission if required
      var actPerm = await Permission.activityRecognition.status;
      if (actPerm.isDenied) await Permission.activityRecognition.request();

      // Request notification permission if required
      var notPerm = await Permission.accessNotificationPolicy.status;
      if (notPerm.isDenied) await Permission.accessNotificationPolicy.request();

      // Request unrestricted battery usage (for background notifications)
      var batPerm = await Permission.ignoreBatteryOptimizations.status;
      if (batPerm.isDenied) await Permission.ignoreBatteryOptimizations.request();
      
    }

    // Call the async function
    onStartFuture();

    // Generate keys that can be accessed from anywhere in state management to 
    // interact with the view
    final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    final navigatorKey = GlobalKey<NavigatorState>();
    
    // Setting the provider which allows access to shared logic and variables
    return MultiProvider(
      // Link the notifier file
      providers: [
        ChangeNotifierProvider(create: (_) => AppNotifier(
          scaffoldKey: scaffoldKey, 
          navigatorKey: navigatorKey,
          prefs: prefs,
        )),
        ChangeNotifierProvider(create: (_) => RunNotifier(
          scaffoldKey: scaffoldKey,
          prefs: prefs,
        )),
      ],
      // Set the app and themedata
      child: FlutterFit(scaffoldKey: scaffoldKey, navigatorKey: navigatorKey)
    );
  }
}

// While this is slighly messy it is the only way to reference the notifier
// variable since I cant define a new variable within a return statement
class FlutterFit extends StatelessWidget {
  const FlutterFit({
    super.key,
    required this.scaffoldKey,
    required this.navigatorKey,
  });

  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    // Define the notifier variable
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    return MaterialApp(
      // Set the title
      title: 'FlutterFit',
      // Assign the key that can be accessed without context
      scaffoldMessengerKey: scaffoldKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        // Force the app to use Material 3
        useMaterial3: true,
      ),
      // Set dark theme
      darkTheme: ThemeData.dark(useMaterial3: true),
      // Tell app which theme to use
      themeMode: notifier.appTheme,
      // Originally load the PageSwitcher which defaults to displaying home
      home: const PageSwitcher(),
    );
  }
}


// App Home page - The initial page selected by PageSwitcher
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<double?> _widthFuture;

  @override
  void initState() {
    super.initState();

    // Initialise app parameters (previously including shared preferences)
    // Now it just starts tracking location for the naerby map if it allowed to
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    notifier.onAppStart();

    // Continusouly send the width and wait for the function to tell us that the
    // width is a valid value
    _widthFuture = whenNotZero(
      Stream<double>.periodic(const Duration(milliseconds: 50),
        (x) => MediaQuery.of(context).size.width
      ),
    );
  }

  // Wait for screen size to be reported by Flutter
  // ignore:body_might_complete_normally_nullable
  Future<double?> whenNotZero(Stream<double> source) async {
    // Await screen size update
    await for (double value in source) {
      // If not 0, return the value
      if (value > 0) {
          return value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final double screenWidth = MediaQuery.of(context).size.width;

    // Make sure that Flutter is reporting a screen width
    return FutureBuilder(
      future: _widthFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          if (snapshot.data! > 0){
            return Scaffold(
              // Stop the screen from resizing on keyboard popup
              // resizeToAvoidBottomInset: false
              // Use a SafeArea to prevent issues from notches and notification bars
              body: SafeArea(
                // While this column seems redundant, it stops the Expanded()
                // widget from taking infinite space
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Column(
                          // Align widgets to centre of column
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // The animated button
                            RepaintBoundary(
                              child: PulsingButton(
                                size: screenWidth,
                              ),
                            ),
                            // The Goal boxes widget
                            const GoalAndTypeContainer(),
                          ],
                        ),
                      )
                    ),
                  ]
                ),
              ),
            );
          }
        }
        // If not ready yet, return an empty scaffold
        return const Scaffold();
      }
    );
  }
}

// Previous notifications code
      /*
      // Request permission for notifications for the local notification package
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();

      // Set local notifications app icon
      const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_notif');
      
      const InitializationSettings initializationSettings = 
        InitializationSettings(
          android: initializationSettingsAndroid
        );
      // Initialize the plugin
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      */