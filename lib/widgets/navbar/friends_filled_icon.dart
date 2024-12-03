import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';

class FriendsFilledIcon extends StatefulWidget {
  const FriendsFilledIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendsFilledIcon> createState() => _FriendsFilledIconState();
}

class _FriendsFilledIconState extends State<FriendsFilledIcon>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;

  @override
  void initState() {
    // Defining the animation controller and duration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    );

    super.initState();

    // Enter curve settings
    final Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    // Interpolate values and set curve
    animation = Tween<double>(begin: 0, end: 1.7).animate(curve)
      // Tell the widget to reload
      ..addListener(() {
        setState(() {});
      });

    // Start the animation or continue if already running
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Return icon at relevant stage of fill based on animation value
    // While using if statements is not clean, it is much faster
    // than other methods, in terms of performance
    // https://stackoverflow.com/questions/6665997/switch-statement-for-greater-than-less-than

    double stage = animation.value;
    // When stage increments by 1, it means 1000 milliseconds have passed
    // Each stage comes at intervals of 0.5, small gap at start to allow finger
    // to lift off screen, so that animation can be seen
    if (stage < 0.2) return const Icon(CustomIcons.friends);
    if (stage < 0.7) return const Icon(CustomIcons.friendsRightFilled);
    if (stage < 1.2) return const Icon(CustomIcons.friendsRightLeftFilled);
    if (stage < 1.7) return const Icon(CustomIcons.friendsFilled);

    // Final return statement, for the sake of null-safety and in case of errors
    return const Icon(CustomIcons.friendsFilled);
  }

  // Animation disposal code
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
