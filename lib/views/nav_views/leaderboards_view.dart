import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';

import 'package:runfun/widgets/friends/leaderboards.dart';
import 'package:runfun/widgets/ui/loader.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class LeaderboardsView extends StatefulWidget {
  const LeaderboardsView({super.key});

  @override
  State<LeaderboardsView> createState() => _LeaderboardsViewState();
}

class _LeaderboardsViewState extends State<LeaderboardsView> {
  late Future<String> _data;

  // Function to update the data for the leaderboards
  void _updateLeaderboardView() {
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    setState(() {
      _data = notifier.updateLeaderboards();
    });
  }

  @override
  void initState() {
    super.initState();
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    // Get leaderboard data on load
    _data = notifier.updateLeaderboards();
  }

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Use tabs
          return DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, boxScrolled) {
                return [
                  // This is required to scroll the title first and then tabs
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context
                    ),
                    sliver: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        title: const Text("Friends and Leaderboards"),
                        pinned: true,
                        floating: true,
                        forceElevated: boxScrolled,
                        bottom: TabBar(
                          // Unfocus text box from previous page
                          onTap: (_) => 
                            FocusManager.instance.primaryFocus?.unfocus(),
                          // Each individual tabs
                          tabs: const [
                            Tab(
                              icon: Icon(CustomIcons.ruler),
                              text: "Distance"
                            ),
                            Tab(
                              icon: Icon(CustomIcons.stopwatch),
                              text: "Time"
                            ),
                            Tab(
                              icon: Icon(CustomIcons.googleSteps),
                              text: "Steps"
                            ),
                          ]
                        )
                      )
                    )
                  )
                ];
              },
              // Each of the individual tab views
              body: TabBarView(
                children: [
                  Leaderboards(
                    world: notifier.worldDistance,
                    friends: notifier.friendsDistance,
                    country: notifier.countryDistance,
                    header: "km",
                    updateLeaderboardFunction: _updateLeaderboardView,
                  ),
                  Leaderboards(
                    world: notifier.worldTime,
                    friends: notifier.friendsTime,
                    country: notifier.countryTime,
                    header: "Minutes",
                    updateLeaderboardFunction: _updateLeaderboardView,
                  ),
                  Leaderboards(
                    world: notifier.worldSteps,
                    friends: notifier.friendsSteps,
                    country: notifier.countrySteps,
                    header: "Steps",
                    updateLeaderboardFunction: _updateLeaderboardView,
                  ),
                ],
              )
            ) 
          );
        } else {
          return const Loader(text: "Friends Loading");
        }
      }
    );
  }
}