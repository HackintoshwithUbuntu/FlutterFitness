import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class NameModal extends StatefulWidget {
  final bool isFname;
  const NameModal({super.key, required this.isFname});

  @override
  State<NameModal> createState() => _NameModalState();
}

class _NameModalState extends State<NameModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    // Wrap everything within a curved container
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        ),
        color: Theme.of(context).dialogBackgroundColor,
      ),
      // Hardcode a height
      height: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 24
            ),
            // Choose the required title
            child: Text(
              "Change ${widget.isFname ? 'First Name' : 'Last Name'}",
              style: const TextStyle(
                fontSize: 24
              ),
            ),
          ),
          // The input box
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: _controller,
                  autocorrect: false,
                  inputFormatters: [
                    // Use regex to filter
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    // Limit input length to 16
                    LengthLimitingTextInputFormatter(16),
                  ],
                  decoration: InputDecoration(
                    labelText: 'New ${widget.isFname?'First Name':'Last Name'}',
                    border: const OutlineInputBorder(),
                  ),
                )
              ),
            )
          ),
          // Buttons to confirm or cancel
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(), 
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Cancel"),
                )
              ),
              const SizedBox(height: 0, width: 8),
              FilledButton(
                onPressed: () => notifier.changeName(
                  _controller.text, 
                  widget.isFname
                ), 
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Submit"),
                )
              ),
              const SizedBox(height: 0, width: 6),
            ]
          ),
          const SizedBox(height: 8, width: 0)
        ]
      )
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
}
