import 'package:flutter/material.dart';


class Loader extends StatelessWidget {
  final String text;
  const Loader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // Returns a loading spinner and some text when called
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spin indefinitely
          const CircularProgressIndicator(value: null),
          const SizedBox(height: 16),
          Text(
            text, 
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 24
            )
          ),
        ],
      ),
    );
  }
}