import 'package:flutter/material.dart';

class HistoryStat extends StatelessWidget {
  final IconData icon;
  final String value;
  const HistoryStat({super.key, required this.icon, required this.value});

  // Quick little bulider class for icon and value for history summary stats
  // helps to make code clean and reusable
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget> [
        Icon(icon),
        const SizedBox(height: 0, width: 5),
        Text(value),
      ],
    );
  }
}
