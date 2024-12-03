import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';

class HomeFilledIcon extends StatefulWidget {
  const HomeFilledIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeFilledIcon> createState() => _HomeFilledIconState();
}

class _HomeFilledIconState extends State<HomeFilledIcon>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController _controller;

  @override
  void initState() {
    // Defining the animation controller and duration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    super.initState();

    // Enter curve settings
    final Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
      reverseCurve: Curves.bounceIn,
    );
    // Set offset values and specify animation curve
    animation = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, -1.0))
        .animate(curve)
      // Tell the widget to reload
      ..addListener(() {
        setState(() {});
      })
      // Reverse animation on forward completion
      ..addStatusListener((status) {
        //print("$status");
        if (status == AnimationStatus.completed) _controller.reverse();
      });

    // Start the animation or continue if already running
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Return slide animation object with icon as child
    // and position / slide according to the animation object value
    return SlideTransition(
      position: animation, 
      child: const Icon(CustomIcons.homeFilled)
    );
  }

  // Animation disposal code
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
