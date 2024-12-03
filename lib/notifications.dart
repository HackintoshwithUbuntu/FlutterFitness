import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

/*
// A function to start the background notification scheduler
@pragma('vm:entry-point') // Tell compiler not to treeshake the code
Future<void> scheduleNotifs() async {
  // Set time of notification, noting that the past is not a valid time
  DateTime now = DateTime.now();
  DateTime todayNotifTime = DateTime(now.year, now.month, now.day, 21, 15);
  DateTime tomorrowNotifTime = DateTime(now.year, now.month, now.day+1, 21, 15);
  late DateTime chosenNotifTime;
  // If now before todays notif time, set today, else set tomorrow
  if (now.compareTo(todayNotifTime) < 0) {
    chosenNotifTime = todayNotifTime;
  } else {
    chosenNotifTime = tomorrowNotifTime;
  }
  // Calculate time remaining until need to send notification
  Duration notifTimeRemaining = chosenNotifTime.difference(now);

  print("INIT task being run");

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager().registerPeriodicTask(
    "NotifDaily",
    "NotifSender",
    // Replace the old task to help realign with correct time if needed
    existingWorkPolicy: ExistingWorkPolicy.replace,
    initialDelay: notifTimeRemaining,
    frequency: const Duration(minutes: 15),
  );

  return;
}*/

@pragma('vm:entry-point')
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var random = Random();

  @pragma('vm:entry-point')
  Future<void> initNotification() async {
    // Request permission for notifications for the local notification package
    //flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      //AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();

    // Set local notifications app icon
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_stat_notif'); // 'ic_stat_notif' 'app_icon'
    
    const InitializationSettings initializationSettings = 
      InitializationSettings(
        android: initializationSettingsAndroid
      );

    // Initialize the plugin with settings
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @pragma('vm:entry-point')
  Future<void> showNotif(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      random.nextInt(9000), 
      title, 
      body, 
      const NotificationDetails(
        android: AndroidNotificationDetails('0', "General")
      )
    );
  }
}

// Callback that the Workmanager calls to send notifications
@pragma('vm:entry-point') 
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // List of possible messages that could be shown
    List<String> messages = ["Runners are 36% more likely to be happy than non-runners", "Running helps you stay healthy", "Walking is a great way to enjoy your local park", "On average, runners live 23% longer than non-runners", "Why not go outside and exercise?", "Why not go for a run?", "Why not go for a walk?"];

    // Since this runs isolated, prefs need to be loaded back ing
    final prefs = await SharedPreferences.getInstance();
    await NotificationService().initNotification();

    var random = Random();

    // If logged in, add messages using their name
    if (prefs.getBool("loginStatus") == true) {
      String fname = prefs.getString("fname")!;
      messages.add("Hey $fname, the weather is looking great outside, maybe perfect for a run...");
      messages.add("Hey $fname, instead of watching Netflix, why not go outside?");
      messages.add("Hey $fname, checkout the leaderboards");
      messages.add("Hey $fname, have you went on a run today?");
      messages.add("Hey $fname, running keeps you healthy");
      messages.add("Hey $fname, walking is a great way to relax");
    }

    // Randomly choose message to show then show a message
    int messageChosen = random.nextInt(messages.length);
    await NotificationService()
      .showNotif("Daily Reminder", messages[messageChosen]);

    // Return true when the task executed successfully
    return Future.value(true);
  });
}


/*
    Stream<StepCount> stepStream = Pedometer.stepCountStream;
    
    // Check for steps since previous day
    Future<void> stepChecker(int totalSteps) async {
      int? prevTotalSteps = prefs.getInt("prevSteps");
      Logger().e("inside stepcheckr funct"); 
  
      // If no previous step data, start filling
      if (prevTotalSteps == null) {
        await NotificationService().showNotif("Daily Reminders", "prevsteps is null");       // TODO remove
        await prefs.setInt("prevSteps", totalSteps);
        return;
      } else {
        //await NotificationService().showNotif("Daily Reminders", "prevsteps is $prevTotalSteps");     // TODO remove
        // Calculate todays steps
        int todaySteps = totalSteps - prevTotalSteps;
        // Save for steps for next calculation
        await prefs.setInt("prevSteps", totalSteps);
        //Logger().e("prev total steps is $prevTotalSteps"); 
        //Logger().e("total steps is $totalSteps"); 

        // Add appropriate messages
        if (todaySteps < 2500) {
          messages.add("You've only taken $todaySteps steps today, why not go outside and exercise?");
          messages.add("You've only taken $todaySteps steps today, why not go for a run?");
          messages.add("You've only taken $todaySteps steps today, why not go for a walk?");
          return;
        }
        if (todaySteps > 10000) {
          messages.add("Legendary Stuff, you took $todaySteps steps today");
          messages.add("Amazing, you took $todaySteps steps today. What do you think about pushing yourself for more?");
          return;
        }
        messages.add("You took $todaySteps steps today, increase that number by going for a run!");
        messages.add("You took $todaySteps steps today. Nice work!");
        messages.add("You took $todaySteps steps today, why not go for a walk?");
      }
    }

    Future<void> addStepNotifs () async {
      int counter = 0;
      await for (StepCount event in stepStream) {
        await stepChecker(event.steps);
        Logger().e(event.steps); 
        counter++;
        if (counter == 3) return;
      }
    }

    await addStepNotifs();
    */