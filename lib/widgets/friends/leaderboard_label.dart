import 'package:flutter/material.dart';

class LeaderboardLabel extends StatelessWidget {
  final IconData icon;
  final String title;
  const LeaderboardLabel({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    // Label for a leaderboard
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary
            ),
          )
        ]
      ),
    );
  }
}
