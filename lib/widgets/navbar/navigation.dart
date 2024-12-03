import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';
import 'package:runfun/widgets/navbar/friends_filled_icon.dart';
import 'package:runfun/widgets/navbar/history_filled_icon.dart';
import 'package:runfun/widgets/navbar/home_filled_icon.dart';
import 'package:runfun/widgets/navbar/location_filled_icon.dart';
import 'package:runfun/widgets/navbar/settings_filled_icon.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';


class Navigation extends StatefulWidget {
  const Navigation({
    Key? key,
  }) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context);
    
    return NavigationBar(
      // Get selected index and update selected on user click
      selectedIndex: notifier.currentPageIndex,
      onDestinationSelected: (int index) => notifier.setNavIndex(index),
      // Add navigation destinations
      destinations: <Widget>[ 
        NavigationDestination(
          // Page Index 0 - Home
          // Check if index is selected, if selected use filled icon
          icon: notifier.isIndexSelected(0)
            ? const HomeFilledIcon() // Use animated filled icon widget
            : const Icon(CustomIcons.home),
          // Set hover tooltip and label underneath icon
          label: "Home",
          tooltip: "Home",
        ),
        NavigationDestination(
          // Page Index 1 - Friends
          icon: notifier.isIndexSelected(1)
            ? const FriendsFilledIcon()
            : const Icon(CustomIcons.friends),
          label: "Friends",
          tooltip: "Friends",
        ),
        NavigationDestination(
          // Page Index 2 - Nearby
          icon: notifier.isIndexSelected(2) 
            ? const LocationFilledIcon()
            : const Icon(CustomIcons.location),
          label: "Nearby",
          tooltip: "Nearby",
        ),
        NavigationDestination(
          // Page Index 3 - History
          icon: notifier.isIndexSelected(3) 
            ? const HistoryFilledIcon()
            : const Icon(CustomIcons.history),
          label: "History",
          tooltip: "History",
        ),
        NavigationDestination(
          // Page Index 4 - Settings
          icon: notifier.isIndexSelected(4)
            //? const Icon(CustomIcons.settingsFilled)
            ? const SettingsFilledIcon()
            : const Icon(CustomIcons.settings),
          label: "Settings",
          tooltip: "Settings",
        )
      ],
    );
  }
}
