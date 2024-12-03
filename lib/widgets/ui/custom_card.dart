import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Function()? onTap;

  const CustomCard({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
      borderRadius: BorderRadius.circular(16),
      // Enables tap reactions and onTap functions
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: child,
        ),
      ),
    );
  }
}
