import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runfun/views/nav_views/user_view.dart';

class FriendSearch extends StatelessWidget {
  const FriendSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        // On submitted clear snackbars and push the requested users info
        onSubmitted: (String requested) {
          ScaffoldMessenger.of(context).clearSnackBars();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendView(user: requested))
          );
        },
        autocorrect: false,
        inputFormatters: [
          // Use regex to filter
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
          // Limit input length to 16
          LengthLimitingTextInputFormatter(16),
        ],
        decoration: InputDecoration(
          // Override label behaviour so look is consistent with no borders
          floatingLabelBehavior: FloatingLabelBehavior.never,
          // Set text
          labelText: 'Search for a user',
          hintText: 'Enter a username',
          filled: true,
          // Circular with no border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
                width: 0, 
                style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }
}