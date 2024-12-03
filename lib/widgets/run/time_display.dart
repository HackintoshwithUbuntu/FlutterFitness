import 'package:flutter/material.dart';

import 'dart:async';

import 'package:runfun/run_notifier.dart';
import 'package:provider/provider.dart';

class TimeDisplay extends StatefulWidget {
  const TimeDisplay({super.key});

  @override
  State<TimeDisplay> createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Set up the widget to refresh every 100 milliseconds
    // While in theory the widget could refresh every second, should the widget
    // refresh lose alignment with the time, this would display a slightly
    // incorrect time, essentially by decreasing the refresh time, we can reduce
    // the maximum time misalignment from the actual time
    timer = Timer.periodic(
      const Duration(milliseconds: 100), (Timer timer) => setState((){}));

  }

  @override
  Widget build(BuildContext context) {
    final RunNotifier notifier = Provider.of<RunNotifier>(context);
    return Flexible(
      flex: 4,
      fit: FlexFit.tight,
      child: Center(child: 
        Text(notifier.timeString, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50))
      )
    );
  }

  @override
  void dispose(){
    super.dispose();
    timer?.cancel();
  }
}