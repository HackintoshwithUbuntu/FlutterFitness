import 'package:flutter/material.dart';

import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

import 'package:runfun/run_notifier.dart';
import 'package:provider/provider.dart';


// The length of the animation in seconds
const double animationlength = 7.15;

class RunIntroAnimation extends StatelessWidget {
  RunIntroAnimation(
      {super.key, required this.controller})
      // The animation value here,
      // corresponds to (number of seconds elapsed) * 2
      : circleSize = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            // Run for 0.5 seconds
            curve: const Interval(0.0, (0.5/animationlength), curve: Curves.linear),
          ),
        ),
        // Tha animation value goes to 4, so it is easy to split into quarters
        countdown = Tween<double>(begin: 0.0, end: 4.0).animate(
          CurvedAnimation(
            parent: controller,
            // Run for 4.5 seconds, 1.5 seconds after previous animation
            // This means around 1.12 seconds for each part
            curve: const Interval((2/animationlength), (6.5/animationlength), curve: Curves.linear),
          ),
        ),
        circleClose = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            // Run for 0.5 seconds, the 0.1 second overlap is not noticable
            // It leaves a bit of time at the end for user to react
            curve: const Interval((6.4/animationlength), (6.9/animationlength), curve: Curves.linear),
          ),
        );

  final Animation<double> circleSize;
  final Animation<double> countdown;
  final Animation<double> circleClose;
  final AnimationController controller;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double minDimension = min(screenWidth, screenHeight);
    final RunNotifier notifier = Provider.of<RunNotifier>(context, listen: false);

    ///
    /// Making the background transition in
    /// 

    // Initally display the circle as 0, then make it bigger
    double width = 0;
    double height = 0;
    BorderRadius borderRadius = BorderRadius.circular(100);
    Duration duration = Duration.zero;

    // Immediately start make the circle bigger
    if (circleSize.value >= 0.01) {
      width = minDimension;
      height = minDimension;
      duration = const Duration(milliseconds: 700);
    }
    // When the circle is appraoching max size, morph into a rectangle
    if (circleSize.value >= 0.71) {
      width = screenWidth;
      height = screenHeight;
      duration = const Duration(milliseconds: 300);
      borderRadius = BorderRadius.circular(0);
    }

    ///
    /// Making the numbers count and audio
    /// 

    // A widget to store the displayed text
    Widget? numberWidget;
    final player = AudioPlayer();

    // Only give text a value once the second animation starts
    if (countdown.value >= 0.01){
      // Check which part should be displayed depending on progress
      if (countdown.value <= 1.01) {
        // Play the audio, but only once
        if(notifier.firstplayneeded){
          player.play(AssetSource('sounds/customCountdown.wav'));
          notifier.firstplayneeded = false;
        }

        // Generate the required text widget, with a unique key
        numberWidget = const Text("3",
          key: ValueKey<int>(1),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 60)
        );
      }

      else if (countdown.value <= 2.01) {
        if(notifier.secondplayneeded){
          player.play(AssetSource('sounds/customCountdown.wav'));
          notifier.secondplayneeded = false;
        }

        numberWidget = const Text("2",
          key: ValueKey<int>(2),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 60)
        );
      }

      else if (countdown.value <= 3.01) {
        if(notifier.thirdplayneeded){
          player.play(AssetSource('sounds/customCountdown.wav'));
          notifier.thirdplayneeded = false;
        }

        numberWidget = const Text("1",
          key: ValueKey<int>(3),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 60)
        );
      }

      else if (countdown.value <= 4.01) {
        if(notifier.fourthplayneeded){
          player.play(AssetSource('sounds/customGo.wav'));
          notifier.fourthplayneeded = false;
        }

        numberWidget = const Text("GO!",
          key: ValueKey<int>(4),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 60)
        );
      }
    }

    ///
    /// Making the background transition out
    /// 
    
    // Overwrite the previously set size with a closing one when the closing
    // animation starts
    if (circleClose.value >= 0.01) {
      width = minDimension;
      height = minDimension;
      duration = const Duration(milliseconds: 150);
      borderRadius = BorderRadius.circular(100);
    }

    // When the circle is appraoching min size, morph into a circle
    if (circleClose.value >= 0.41) {
      width = 0;
      height = 0;
      duration = const Duration(milliseconds: 300);
    }

    return Scaffold(
      body: Center(
        // Create a container which updates using the animation
        child: AnimatedContainer(
          width: width,
          height: height,
          // Colour it in black but make borderradius based on animation
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: borderRadius,
            color: Colors.black
          ),
          duration: duration,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                border: Border.all(
                  color: Colors.white, 
                  width: 3
                )
              ),
              // The switcher which shows the countdown text
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                // Transition between numbers
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: numberWidget
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

/* 
    if (circleClose.value == 1.0) {
      // Using a future to make navigator happy or it throws an error on debug mode
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          PageRouteBuilder(pageBuilder: (_, __, ___) => const DuringRun())
        );
      });
      
    }
    */