import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';

class SettingsFilledIcon extends StatefulWidget {
  const SettingsFilledIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsFilledIcon> createState() => _SettingsFilledIconState();
}

class _SettingsFilledIconState extends State<SettingsFilledIcon>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;

  @override
  void initState() {
    // Defining the animation controller and duration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3200),
      vsync: this,
    );

    super.initState();

    // Enter curve settings
    final Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    // Interpolate values and set curve
    animation = Tween<double>(begin: 0, end: 2.25).animate(curve)
      // Tell the widget to reload
      ..addListener(() {
        setState(() {});
      });

    // Start the animation or continue if already running
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Return rotation animation object with icon as child
    // and rotating according to the animation object value
    return RotationTransition(
      turns: animation, child: const Icon(CustomIcons.settingsFilled));
  }

  // Animation disposal code
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
