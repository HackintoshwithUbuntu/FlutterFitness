import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class LoginTextInput extends StatelessWidget {
  const LoginTextInput({
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
              flex: 4,
              fit: FlexFit.tight,
              child: Center(
                child: Text(
                  "Login", 
                  // Style parameters
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              )
            ),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              // The username input
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                child: Column(
                  children: [
                    // Username input
                    TextField(
                      onChanged: (value) => notifier.loginFormUsername = value,
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
                    // Password input
                    TextField(
                      onChanged: (value) => notifier.loginFormPassword = value,
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