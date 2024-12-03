import 'package:flutter/material.dart';

import 'package:runfun/views/run_views/postrun_view.dart';
import 'package:runfun/widgets/ui/show_snackbar.dart';

import 'package:runfun/run_notifier.dart';
import 'package:provider/provider.dart';

class BackButtonBlocker extends StatelessWidget {
  final Widget scaffoldChild;

  const BackButtonBlocker({super.key, required this.scaffoldChild});

  @override
  Widget build(BuildContext context) {
    // A widget which blocks back button presses and redirectes their action
    // to a function which is called
    return WillPopScope(
      onWillPop: () async {
        // Show the dialog
        await showDialogMethod(context);
        return false;
      },
      child: Scaffold(
        body: scaffoldChild,
      )
    );
  }
}

// The return showDialog is a method so can be reused in other place of app
Future<dynamic> showDialogMethod(BuildContext context) {
  RunNotifier runNotifier = Provider.of<RunNotifier>(context, listen: false);
  return showDialog(
    context: context,
    // Display the dialogue
    builder: (context) => AlertDialog(
      title: Text('Finish ${runNotifier.exerciseType}?'),
      content: Text('Do you want to finish the current ${runNotifier.exerciseType.toLowerCase()}'),
      actions: <Widget>[
        // Remove the confirmation if answer is no
        TextButton(
          onPressed: () => {Navigator.of(context).pop()},
          child: const Text('No'),
        ),
        // Finish if the answer is yes
        TextButton(
          onPressed: () => {
            // Check if the user actually went any distance
            if (runNotifier.totalDistance == "0.00") {
              // Remove countdown route and during run view, go back to home
              Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst),
              // Cancel streams
              runNotifier.onPrematureRunFinish(),
              showSnackbar("Run canceled. Insufficient Distance", runNotifier.scaffoldState)
            } else {
              // Push the post run and remove countdown + during run
              Navigator.pushAndRemoveUntil(
                context,
                // Navigate to next page
                MaterialPageRoute(
                    builder: (BuildContext context) => const Postrun()),
                (Route<dynamic> route) => route.isFirst
              )
            }
          }, 
          child: const Text('Yes'),
        ),
      ],
    )
  );
}
