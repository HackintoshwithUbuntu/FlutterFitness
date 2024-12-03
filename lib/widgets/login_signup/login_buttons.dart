import 'package:flutter/material.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);

    // Align to bottom so that seperate from text
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Padding(
            // Gap between buttons
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SizedBox(
              // Make the button take up more width
              width: MediaQuery.of(context).size.width*(2/3),
              child: FilledButton(
                // Call login attempt code
                onPressed: () => {notifier.onLoginPress(context)},
                child: const Text("Login")
              ),
            ),
          ),
          Padding(
            // Bring up button from bottom
            padding: const EdgeInsets.only(bottom: 24.0),
            child: SizedBox(
              // Make the button take up more width
              width: MediaQuery.of(context).size.width*(2/3),
              // Use a tonal button to convey less importance
              child: FilledButton.tonal(
                onPressed: () => notifier.pushSignupPage(context),
                // Redirect to sign up screen
                child: const Text("...Or Sign up instead")
              ),
            ),
          ),
        ],
      )
    );
  }
}