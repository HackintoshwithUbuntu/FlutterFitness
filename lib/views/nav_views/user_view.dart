import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';

import 'package:runfun/widgets/friends/user_stat.dart';
import 'package:runfun/widgets/ui/loader.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class FriendView extends StatefulWidget {
  final String user;
  const FriendView({super.key, required this.user});

  @override
  State<FriendView> createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {
  late Future<List<dynamic>> _data;

  @override
  void initState() {
    super.initState();
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    _data = notifier.getUserInfo(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "User info", 
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  // Username
                  Text(widget.user, style: const TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold
                  )),
                  Text(snapshot.data![0], style: const TextStyle(fontSize: 24)),
                  const Divider(),
                  // Each of the users stats
                  FriendStat(
                    title: "Distance this week",
                    icon: CustomIcons.ruler,
                    value: "${snapshot.data![2]} km"
                  ),
                  FriendStat(
                    title: "Time this week",
                    icon: CustomIcons.stopwatch,
                    value: "${snapshot.data![3]} minutes"
                  ),
                  FriendStat(
                    title: "Steps this week",
                    icon: CustomIcons.googleSteps,
                    value: "${snapshot.data![4]} steps"
                  ),
                  FriendStat(
                    title: "User Country",
                    icon: CustomIcons.flag,
                    value: "${snapshot.data![6]}"
                  ),
                  Row(
                    children: [
                      // Buttons for friending and unfriending
                      FilledButton(
                        child: 
                        Text(
                          notifier.friendStatus 
                            ? "Unfriend user" 
                            : "Friend User"
                        ),
                        onPressed: () => notifier.friendUser(widget.user),
                      ),
                      const SizedBox(height: 0 , width: 8),
                      FilledButton.tonal(
                        onPressed: () {
                          notifier.clearSnackbars();
                          Navigator.of(context).pop();
                        }, 
                        child: const Text("Back")
                      )
                    ]
                  ),
                ]
              ),
            ),
          );
        } else {
          return const Scaffold(body: Loader(text: "User Loading"));
        }
        
      }
    );
  }
}