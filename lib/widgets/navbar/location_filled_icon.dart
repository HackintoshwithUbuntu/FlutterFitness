import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';

class LocationFilledIcon extends StatefulWidget {
  const LocationFilledIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationFilledIcon> createState() => _LocationFilledIconState();
}

class _LocationFilledIconState extends State<LocationFilledIcon>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;

  // Variable to store current animation progress and status
  bool filled = false;

  @override
  void initState() {
    // Defining the animation controller and duration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    super.initState();

    // Enter curve Location
    final Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    // Interpolate values and set curve
    animation = Tween<double>(begin: 24, end: 3).animate(curve)
      // Tell the widget to reload
      ..addListener(() {
        setState(() {});
      })
      // Reverse animation on forward completion
      ..addStatusListener((status) {
        //print("$status");
        if (status == AnimationStatus.completed) {
          _controller.reverse();
          filled = true;
        }
      });

    // Start the animation or continue if already running
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Fix size of container and animate the size of the icon
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: Icon(
          filled 
            ? CustomIcons.locationFilled
            : CustomIcons.location,
          size: animation.value
        ),
      ),
    );
  }

  // Animation disposal code
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}