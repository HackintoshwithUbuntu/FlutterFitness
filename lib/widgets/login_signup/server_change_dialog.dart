import 'package:flutter/material.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class ServerChangeDialog extends StatefulWidget {
  const ServerChangeDialog({super.key});

  @override
  State<ServerChangeDialog> createState() => _ServerChangeDialogState();
}

class _ServerChangeDialogState extends State<ServerChangeDialog> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    return AlertDialog(
      title: const Text('Change Server'),
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'New Server URL',
                border: OutlineInputBorder(),
              )
            ),
          ),
        ],
      ),
      actions: <Widget>[
        // Remove the confirmation if answer is no
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Call the callback if the user is sure
        TextButton(
          onPressed: () => notifier.updateServerUrl(context, _controller.text),
          child: const Text('Update'),
        ),
      ],
    );
  }
}