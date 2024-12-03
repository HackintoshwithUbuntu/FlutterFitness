import 'package:flutter/material.dart';
import 'package:runfun/widgets/settings/other_tiles.dart';

import 'package:runfun/widgets/settings/user_tiles.dart';
import 'package:runfun/widgets/ui/custom_appbar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stop the screen from resizing on keyboard popup
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: <Widget> [
          CustomSliverAppBar(
            title: Text(
              "Settings", 
              style: Theme.of(context).textTheme.titleLarge!
            ),
          ),
          const SliverList(
            delegate: SliverChildListDelegate.fixed(
              <Widget>[
                UserTiles(),
                OtherTiles()
              ]
            )
          )
        ]
      )
    );
  }
}