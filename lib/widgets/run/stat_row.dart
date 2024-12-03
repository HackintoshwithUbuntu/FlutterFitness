import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

// FILE IS NOT USED IN CURRENT IMPLEMENTATION, SEE STAT_DISPLAY.DART INSTEAD

class StatRow extends StatefulWidget {
  final String labelLeft;
  final String labelRight;
  final String statLeft;
  final String statRight;
  
  const StatRow({
    super.key, 
    required this.labelLeft, 
    required this.labelRight, 
    required this.statLeft, 
    required this.statRight,
  });

  @override
  State<StatRow> createState() => _StatRowState();
}

class _StatRowState extends State<StatRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget> [
        Flexible(child:
          Column(
            children: [
              Text(widget.labelLeft),
              Text(widget.statLeft, style: GoogleFonts.righteous(fontSize: 48)),
            ],
          )
        ), 
        Flexible(child:
          Column(
            children: [
              Text(widget.labelRight),
              Text(widget.statRight, style: GoogleFonts.righteous(fontSize: 48)),
            ],
          )
        )
      ]
    );
  }
}