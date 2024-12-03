import 'package:flutter/material.dart';

class SettingsLabel extends StatelessWidget {
  final String text;
  const SettingsLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 20.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary
        ),
      ),
    );
  }
}
