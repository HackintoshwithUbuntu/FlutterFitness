import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class PostrunInitialInfo extends StatelessWidget {
  const PostrunInitialInfo({
    super.key,
    required this.totalDistance,
    required this.startEndTimeString,
    required this.isCheating
  });

  final String totalDistance;
  final String startEndTimeString;
  final bool isCheating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display distance and kilometers
          Text("$totalDistance kilometers", style: GoogleFonts.righteous(fontSize: 40)),
          // Show date and times of start and end
          Text(startEndTimeString),
          // If suspected cheating, show warning
          if (isCheating) 
            Text(
              "This run data seems unusual, it will not be included in leaderboards",
              style: TextStyle(color: Colors.red.shade700)
            ),
          // Keep a small gap with widgets below
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}