import 'package:flutter/material.dart';

import 'package:runfun/widgets/ui/back_button_blocker.dart';
import 'package:runfun/widgets/run/run_intro_animation.dart';

import 'package:runfun/views/run_views/during_run_view.dart';

import 'package:runfun/main_notifier.dart';
import 'package:runfun/run_notifier.dart';
import 'package:provider/provider.dart';


class RunView extends StatefulWidget {
  const RunView({super.key});

  @override
  State<RunView> createState() => _RunViewState();
}

class _RunViewState extends State<RunView> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    final AppNotifier appNotifier = Provider.of<AppNotifier>(context, listen: false);
    final RunNotifier runNotifier = Provider.of<RunNotifier>(context, listen: false);

    // Copy variables to the run notifier
    runNotifier.setRunVariables(appNotifier.goal, appNotifier.exercise, 
      appNotifier.goalValueNum, appNotifier.goalValueString);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 7150),
      vsync: this
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // On animation complete, go to the next page
            Navigator.push(
              context,
              PageRouteBuilder(pageBuilder: (_, __, ___) => const DuringRun())
            );
        }
      });
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // The animation got canceled, probably because it was disposed of
      // Do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    // Remove any remaining snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Start or continue the animation
    _playAnimation();

    // Use custom back button handling and display the 3,2,1 GO animation
    return BackButtonBlocker(
      scaffoldChild: RunIntroAnimation(controller: _controller)
    );
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 