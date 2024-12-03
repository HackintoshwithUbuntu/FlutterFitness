import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const CustomListTile({
    super.key, 
    required this.title, 
    required this.subtitle, 
    this.trailing,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      // Main title
      title: Text(
        title, 
        style: const TextStyle(
          fontSize: 20,
        )
      ),
      // Subtitle
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).hintColor,
        )
      ),
      // Pass trailing and onTap if needed
      trailing: trailing,
      onTap: onTap,
    );
  }
}
