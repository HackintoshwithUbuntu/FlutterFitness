import 'package:flutter/material.dart';

import 'package:runfun/widgets/login_signup/login_buttons.dart';
import 'package:runfun/widgets/login_signup/login_text_input.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        // Stop the screen from resizing on keyboard popup
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            LoginTextInput(),
            LoginButtons()
          ],
        ),
      )
    );
  }
}

