import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';
import 'package:runfun/widgets/friends/user_search.dart';

import 'package:runfun/widgets/friends/leaderboard_card.dart';
import 'package:runfun/widgets/friends/leaderboard_label.dart';

class Leaderboards extends StatelessWidget {
  final List<dynamic> world;
  final List<dynamic> friends;
  final List<dynamic> country;
  final String header;
  final VoidCallback updateLeaderboardFunction;

  const Leaderboards({
    super.key, 
    required this.world, 
    required this.friends, 
    required this.country,
    required this.header,
    required this.updateLeaderboardFunction
  });

  @override
  Widget build(BuildContext context) {
    // Put the leaderboard in its own scrollview
    return RefreshIndicator(
      onRefresh: () async {
        updateLeaderboardFunction();
      },
      child: SingleChildScrollView(
      child: Column(
        children: [
          // Search for a friend
          const FriendSearch(),
          // World leaderboard
          const LeaderboardLabel(
            icon: CustomIcons.googleWorld, 
            title: "World Leaderboard"
          ),
          // The leaderboard card with a title set to the relevant unit
          LeaderboardCard(data: world, header: header),
    
          // Friends Leaderboard
          const LeaderboardLabel(
            icon: CustomIcons.friends, 
            title: "Friends Leaderboard"
          ),
          LeaderboardCard(data: friends, header: header),
    
          // Country Leaderboard
          const LeaderboardLabel(
            icon: CustomIcons.flag, 
            title: "Country Leaderboard"
          ),
          LeaderboardCard(data: country, header: header),
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                "Leaderboards are reset at 00:00 Sunday GMT every week",
                style: TextStyle(
                  color: Colors.grey, fontSize: 14
                )
              ),
            ),
          )
        ],
      ),
    ));
  }
}


