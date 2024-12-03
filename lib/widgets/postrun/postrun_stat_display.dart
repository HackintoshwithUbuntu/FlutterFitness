import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class PostrunStatDisplay extends StatefulWidget {
  final String label;
  final String stat;
  
  const PostrunStatDisplay({
    super.key, 
    required this.label, 
    required this.stat, 
  });

  @override
  State<PostrunStatDisplay> createState() => _PostrunStatDisplayState();
}

class _PostrunStatDisplayState extends State<PostrunStatDisplay> {
  @override
  Widget build(BuildContext context) {
    // Display a stat with Google font and with its label and value
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(widget.label, textAlign: TextAlign.center),
        Text(widget.stat, 
          textAlign: TextAlign.center,
          style: GoogleFonts.righteous(fontSize: 36)
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}