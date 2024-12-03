import 'package:flutter/material.dart';

import 'package:runfun/widgets/postrun/postrun_stat_display.dart';

class PostrunStatTable extends StatelessWidget {
  // This file does not fetch from notifier so that the widget is reusable
  // and interchangable between the history and postrun views
  final String timeString;
  final String totalSteps;
  final String avgSpeed;
  final String timePerKm;
  final String stepsPerKm;
  final String cadence;
  final String totalAltGain;
  
  const PostrunStatTable({
    super.key,
    required this.timeString,
    required this.totalSteps,
    required this.avgSpeed,
    required this.timePerKm,
    required this.stepsPerKm,
    required this.cadence,
    required this.totalAltGain
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Show the trio of stats at the top
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PostrunStatDisplay(label: "Time", stat: timeString),
            PostrunStatDisplay(label: "Steps", stat: totalSteps),
            PostrunStatDisplay(label: "Speed (km/h)", stat: avgSpeed),
          ],
        ),
        // Display the 2x2 in a table so items in rows are aligned
        Table(
          columnWidths: const {
            // Set each to half screen size
            0: FlexColumnWidth(1), 
            1: FlexColumnWidth(1)
          },
          children: [
            TableRow(
              children: [
                PostrunStatDisplay(label: "Time per km", stat: timePerKm),
                PostrunStatDisplay(label: "Steps per km", stat: stepsPerKm),
              ]
            ),
            TableRow(
              children: [
                PostrunStatDisplay(label: "Cadence", stat: cadence),
                PostrunStatDisplay(label: "Altitude Gain (m)", stat: totalAltGain),
              ]
            ),
          ]
        ),
      ],
    );
  }
}
