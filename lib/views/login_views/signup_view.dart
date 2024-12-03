import 'package:flutter/material.dart';

import 'package:runfun/widgets/login_signup/signup_buttons.dart';
import 'package:runfun/widgets/login_signup/signup_text_input.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        // Stop the screen from resizing on keyboard popup
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SignupTextInput(),
            SignupButtons()
          ],
        ),
      )
    );
  }
}