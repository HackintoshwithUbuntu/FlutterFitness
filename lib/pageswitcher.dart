import 'package:flutter/material.dart';

import 'package:runfun/main.dart';
import 'package:runfun/views/nav_views/history_view.dart';
import 'package:runfun/views/nav_views/nearby_view.dart';
import 'package:runfun/views/nav_views/leaderboards_view.dart';
import 'package:runfun/views/nav_views/settings_view.dart';

import 'package:runfun/widgets/navbar/navigation.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

import 'package:animations/animations.dart';

// This widget forms a countainer within which the page is updated, with an 
// animation, but the navigation bar is not refreshed
// Adapted from:
// https://github.com/JGeek00/droid-hole/blob/master/lib/base.dart
// and https://github.com/revanced/revanced-manager/blob/flutter/lib/ui/views/navigation/navigation_view.dart


class PageSwitcher extends StatelessWidget {
  const PageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The list of widgets to switch between
    const List<Widget> pages = [HomeView(), LeaderboardsView(), NearbyView(), HistoryView(), SettingsView()];
    AppNotifier notifier = Provider.of<AppNotifier>(context);

    // Return scaffold with its body as the selected view and a seperate navbar
    // that does not change when the body is updated
    return Scaffold(
      resizeToAvoidBottomInset: false, // This setting can be overriden by nested scaffolds
      body: PageTransitionSwitcher(
        // Set duration
        duration: const Duration(milliseconds: 200),
        // Build our fade through transition
        transitionBuilder: (
          (child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
            animation: primaryAnimation, 
            secondaryAnimation: secondaryAnimation,
            fillColor: Theme.of(context).colorScheme.surface,
            child: child,
          )
        ),
        // Update the Scaffold body to current index, by setting transition child
        child: pages[notifier.currentPageIndex],
      ),
      // The bottom navigation bar which is seperate to the scaffold body and
      // hence does not get animated on a page transition. Animations such as
      // highlights for the selected page are handled independently by the 
      // stateful widget functions of the navigation widget
      bottomNavigationBar: const Navigation()
    );
  }
}
