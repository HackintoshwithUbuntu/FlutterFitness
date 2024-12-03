import 'package:flutter/material.dart';

class PostrunMaptext extends StatelessWidget {
  const PostrunMaptext({super.key});

  @override
  Widget build(BuildContext context) {
    // Just the map title
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Run Map",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium!,
        ),
      ),
    );
  }
}
