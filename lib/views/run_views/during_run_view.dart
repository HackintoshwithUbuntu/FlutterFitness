import 'package:flutter/material.dart';

import 'dart:async';

import 'package:runfun/widgets/ui/back_button_blocker.dart';
import 'package:runfun/widgets/run/time_display.dart';
import 'package:runfun/widgets/run/stat_table.dart';
import 'package:runfun/icons.dart';

import 'package:runfun/run_notifier.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class DuringRun extends StatefulWidget {
  const DuringRun({super.key});

  @override
  State<DuringRun> createState() => _DuringRunState();
}

class _DuringRunState extends State<DuringRun> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  Timer? timer;
  Timer? goalTimer;

  @override
  void initState() {
    super.initState();
    final RunNotifier notifier = Provider.of<RunNotifier>(context, listen: false);
    // Tell the code to start timing and other collection paramters
    notifier.onRunStart();

    // Fade animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this
    );

    // Animate from 0 to 1
    animation = Tween(
      begin: 0.0,
      end: 1.0
    ).animate(_controller);

    // Set up the widget to refresh every second
    timer = Timer.periodic(
      const Duration(seconds: 1), (Timer timer) => setState((){}));

    // Check whether the goal has been achieved every 2 seconds
    goalTimer = Timer.periodic(
      const Duration(seconds: 2), (Timer goalTimer) => notifier.checkGoal());

    // Start animation or continue if already started
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    const double indent = 17;
    final RunNotifier notifier = Provider.of<RunNotifier>(context);

    return SafeArea(
      child: Scaffold(
        // Wrap in a fade transition controlled by the contoller to make fade in
        body: FadeTransition(
          opacity: animation,
          child: BackButtonBlocker(
            scaffoldChild: Column(
              children: <Widget>[
                // Show time with a flex of 4
                const TimeDisplay(),
                const Divider(indent: indent, endIndent: indent),
                // Show all the stats and pass the values to the table
                Flexible(
                  flex: 4,
                  child: StatTable(
                    indent: indent, 
                    totalDistance: notifier.totalDistance, 
                    totalAltGain: notifier.totalAltGain,
                    totalSteps: notifier.totalSteps,
                    cadence: notifier.cadence,
                  ),
                ),
                const Divider(indent: indent, endIndent: indent),
                // Display the goal
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      const Text("Goal"),
                      Text(
                        notifier.goalValueString, 
                        textAlign: TextAlign.center, 
                        style: GoogleFonts.righteous(fontSize: 60)
                      ),
                    ],
                  )
                ), 
                // Flexible that takes up one space to leave area for buttons
                Flexible(child: Container())
              ],
            )
          ),
        ),
        // The button to end the run
        floatingActionButton: Padding(
          // Move it slightly up from the bottom of the page
          padding: const EdgeInsets.only(bottom: 16.0),
          // Use the big button
          child: FloatingActionButton.extended(
            // Call the quit run dialogue
            onPressed: () async {
              await showDialogMethod(context);
            },
            label: Text("Finish ${notifier.exerciseType}"),
            icon: const Icon(CustomIcons.googleFinish)
          ),
        ),
        // Put in centre
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // Cencel timer on widget destruction
    timer?.cancel();
    goalTimer?.cancel();
    super.dispose();
  }
}

            /*
            const Flexible(
              flex: 2,
              child: StatRow(
                labelLeft: "Distance", 
                statLeft: "3.2", 
                labelRight: "Steps", 
                statRight: "2023"
              ),
            ),
            const Divider(indent: indent, endIndent: indent),
            const Flexible(
              flex: 2,
              child: StatRow(
                labelLeft: "Height Gain", 
                statLeft: "23", 
                labelRight: "Cadence", 
                statRight: "180"
              ),
            ),
            */