import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class StatDisplay extends StatefulWidget {
  final String label;
  final String stat;
  
  const StatDisplay({
    super.key, 
    required this.label, 
    required this.stat, 
  });

  @override
  State<StatDisplay> createState() => _StatDisplayState();
}

class _StatDisplayState extends State<StatDisplay> {
  @override
  Widget build(BuildContext context) {
    // Display a stat with Google font and with its label and value
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(widget.label, textAlign: TextAlign.center),
        Text(widget.stat, 
          textAlign: TextAlign.center,
          style: GoogleFonts.righteous(fontSize: 48)
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}