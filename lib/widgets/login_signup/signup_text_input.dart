import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class SignupTextInput extends StatelessWidget {
  const SignupTextInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    
    return Expanded(
      // Align text to center, the buttons are aligned to bottom
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget> [
            // Show the title and space it away from other widgets by forcing
            // it to the centre of its flex
            const Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Signup", 
                      // Style parameters
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    Text("Use only letters and numbers, keep under 16 characters")
                  ],
                ),
              )
            ),
            // Show the inputs
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              // The username input
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => notifier.signupFormUsername = value,
                      autocorrect: false,
                      inputFormatters: [
                        // Use regex to filter
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                        // Limit input length to 16
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Divide the inputs
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) => notifier.signupFormPassword = value,
                      obscureText: true,
                      autocorrect: false,
                      inputFormatters: [
                        // Use regex to filter
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                        // Limit input length to 16
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        // helperText: 'error message', this is text at bottom
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) => 
                        notifier.signupFormPasswordConfirm = value,
                      obscureText: true,
                      autocorrect: false,
                      inputFormatters: [
                        // Use regex to filter
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                        // Limit input length to 16
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                        // helperText: 'error message', this is text at bottom
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) => notifier.signupFormFname = value,
                      autocorrect: false,
                      inputFormatters: [
                        // Use regex to filter
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        // Limit input length to 16
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) => notifier.signupFormLname = value,
                      autocorrect: false,
                      inputFormatters: [
                        // Use regex to filter
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        // Limit input length to 16
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}