import 'package:flutter/material.dart';

import 'package:avatar_glow/avatar_glow.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class PulsingButton extends StatefulWidget {
  final double size;

  const PulsingButton(
      {Key? key, required this.size})
      : super(key: key);

  @override
  State<PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late double minSize, maxSize;

  @override
  void initState() {
    // Calculate animation paramaters
    minSize = widget.size / 5;
    maxSize = widget.size / 3.3;

    super.initState();
    // Set the animation controller
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Enter curve settings
    final Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInCirc,
      reverseCurve: Curves.easeOutCirc,
    );
    // Interpolate values and set curve
    animation = Tween<double>(begin: minSize, end: maxSize).animate(curve)
      // Tell the widget to reload
      ..addListener(() {
        setState(() {});
      });

    // Start the animation or continue if already running, repeat on complete
    // and reverse if complete in one direction
    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    // Get current exercise type and generate text
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    String pulsetext = "Start ${notifier.exercise}";

    // Using the AvatarGlow library to create effect around the button
    // Many of the following values adapt based on screen size
    return AvatarGlow(
      // AvatarGlow Settings
      glowColor: Colors.purple,
      endRadius: (widget.size / 2.6),
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: false,
      // Show every two seconds
      repeatPauseDuration: const Duration(milliseconds: 2000),
      child: ElevatedButton(
        // On pressed call function which evaluates what to do next
        onPressed: () => notifier.onStartPress(context),
        style: ElevatedButton.styleFrom(
          // Make it a circle
          shape: const CircleBorder(),
          // Size based on animation
          padding: EdgeInsets.all(animation.value),
        ),
        // Add the text
        child: Text(pulsetext),
      )
    );
  }

  // Animation controller disposal function
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


// Original attempt at stateless widget, that had to be converted
/*class PulsingButton extends StatelessWidget {
  final String text;
  final double size;

  const PulsingButton({
    Key? key,
    required this.text,
    required this.size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: Colors.blue,
      endRadius: (size/2.6),
      duration: const Duration(milliseconds: 2200),
      repeat: true,
      showTwoGlows: false,
      repeatPauseDuration: const Duration(milliseconds: 30),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(size/4.5),
        ),
        child: Text(text),
      )
    );
  }
}*/


// Old Way to Animate, this animation code has been replaced by a cleaner
// implementation
    // Enter animation settings
    /*
    animation = Tween<double>(begin: 100, end: 150).animate(controller)
      // Tell the widget to reload
      ..addListener(() {setState(() {});})
      // Reversing animation code
      ..addStatusListener((status) {
        // Forever reverse the animation
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
      */
    //..addStatusListener((status) => print('$status')); <- to check animation status


//////////////////////////////
// The attempt at an animated widget that stopped working for some reason
/////////////////////////////


/*
// The class for making the actual button UI elements
class PulsingButtonBuilder extends AnimatedWidget {
  // Passed though variables, including animation and press function
  final String text;
  final double size;
  final VoidCallback? onPressed;  // Void call back is a void function

  const PulsingButtonBuilder(
      {super.key,
      required Animation<double> animation,
      required this.text,
      required this.size, this.onPressed})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    // Notify on animation update
    final animation = listenable as Animation<double>;
    // Using the AvatarGlow library to create effect around the button
    // Many of the following values adapt based on screen size
    return AvatarGlow(
        // AvatarGlow Settings
        glowColor: Colors.blue,
        endRadius: (size / 2.6),
        duration: const Duration(milliseconds: 2200),
        repeat: true,
        showTwoGlows: false,
        repeatPauseDuration: const Duration(milliseconds: 30),
        // Button maker
        child: ElevatedButton(
          // Elevated button requires an onPressed value, 
          // so we have told it to do nothing here,
          // the parent widget manages onPressed
          onPressed: onPressed, 
          style: ElevatedButton.styleFrom(
            // Make it a circle
            shape: const CircleBorder(),
            // Size based on animation
            padding: EdgeInsets.all(animation.value),
          ),
          // Add the text, based on input
          child: Text(text),
        ));
  }
}

// The wrapper widget which I access from the main file
class PulsingButton extends StatefulWidget {
  // Inputs that will primarily be forwarded to builder
  final String text;
  final double size;
  final VoidCallback? onPressed; 

  const PulsingButton({Key? key, required this.text, required this.size, this.onPressed})
      : super(key: key);

  @override
  State<PulsingButton> createState() => _PulsingButtonState();
}

// Main state with tick provider
class _PulsingButtonState extends State<PulsingButton>
    with SingleTickerProviderStateMixin {
  // Defining animation variables that will be assigned on init
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // Set the animation controller
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Enter animation settings
    animation = Tween<double>(begin: 100, end: 150).animate(controller)
      ..addStatusListener((status) {
        // Forever reverse the animation
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    //..addStatusListener((status) => print('$status')); <- to check animation status

    // Start the animation or continue it if already running
    controller.forward();
  }

  // Use the builder function and pass on inputed values
  @override
  Widget build(BuildContext context) => PulsingButtonBuilder(
        animation: animation,
        size: widget.size,
        text: widget.text,
      );

  // Animation controller disposal function
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
*/