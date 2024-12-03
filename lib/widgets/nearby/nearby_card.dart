import 'package:flutter/material.dart';
import 'package:runfun/icons.dart';

import 'package:runfun/main_notifier.dart';

class NearbyCard extends StatelessWidget {
  const NearbyCard({
    super.key,
    required this.notifier,
  });

  final AppNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: RepaintBoundary(
        child: Card(
          elevation: 3,
          // Use a column to limit the height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Use intrinsic height to size widget more effectively
              IntrinsicHeight(
                // Use row to stretch across width
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The main data aligned to left
                    Align(
                      alignment: Alignment.centerLeft,
                      // Final column for vertical layout
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Column(
                          // Align things to the top and then to the left
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show username
                            Text(
                              notifier.shownNearbyUname,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 32
                              ),
                              textAlign: TextAlign.left,
                            ),
                            // Show real name
                            Text(
                              "aka ${notifier.shownNearbyName}", 
                              style: const TextStyle(
                                color: Colors.grey, fontSize: 12
                              )
                            ),
                            // Show divider
                            const SizedBox(
                              width: 100,
                              height: 10,
                              child: Divider()
                            ),
                            // Show distance away, computed elsewhere
                            Text(
                              "Distance away: ${notifier.shownNearbyDistance}m"
                            ),
                            // Show time last updated
                            Text(
                              "Last updated: ${notifier.shownNearbyUpdate} seconds ago"
                            )
                          ],
                        ),
                      ),
                    ),
                    // The close button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(CustomIcons.cross),
                        onPressed: () {
                          notifier.leftNearby();
                        },
                      )
                    )
                  ] 
                ),
              )          
            ]
          )
        ),
      ),
    );
  }
}