import 'package:flutter/material.dart';

class FriendStat extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  const FriendStat({
    super.key, 
    required this.title, 
    required this.icon, 
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show a title then an icon and text in a row underneath
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary
          ),
        ),
        Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 0, width: 6),
            Text(value, style: const TextStyle(fontSize: 32))
          ]
        )
      ]
    );
  }
}
