import 'package:flutter/material.dart';

import 'package:runfun/widgets/ui/custom_appbar.dart';
import 'package:runfun/widgets/postrun/postrun_alt_graph.dart';
import 'package:runfun/widgets/postrun/postrun_initial_info.dart';
import 'package:runfun/widgets/postrun/postrun_map.dart';
import 'package:runfun/widgets/postrun/postrun_maptext.dart';
import 'package:runfun/widgets/postrun/postrun_stat_table.dart';

import 'package:runfun/main_notifier.dart';
import 'package:provider/provider.dart';

class HistoryRunView extends StatefulWidget {
  final String fileName;
  const HistoryRunView({super.key, required this.fileName});

  @override
  State<HistoryRunView> createState() => _HistoryRunViewState();
}

class _HistoryRunViewState extends State<HistoryRunView> {

  @override
  Widget build(BuildContext context) {
    AppNotifier notifier = Provider.of<AppNotifier>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: notifier.getRundataFromFile(widget.fileName),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Future hasn't finished yet, return a placeholder
            return const Center(child: CircularProgressIndicator(value: null));
          }
          // Make it scrollable
          return CustomScrollView(
            slivers: <Widget>[
              CustomSliverAppBar(
                showBack: true,
                title: Text(
                  "Historical ${snapshot.data!['exerciseType']}", 
                  style: Theme.of(context).textTheme.titleLarge!
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  <Widget>[
                    // Show Distance, Start time and End time
                    PostrunInitialInfo(
                      totalDistance: snapshot.data!["totalDistance"],
                      startEndTimeString: snapshot.data!["startEndTimeString"],
                      isCheating: snapshot.data!["isCheating"],
                    ), 
                    // Show the main stats
                    PostrunStatTable(
                      timeString: snapshot.data!["timeString"],
                      totalSteps: snapshot.data!["totalSteps"],
                      avgSpeed: snapshot.data!["avgSpeed"],
                      timePerKm: snapshot.data!["timePerKm"],
                      stepsPerKm: snapshot.data!["stepsPerKm"],
                      cadence: snapshot.data!["cadence"],
                      totalAltGain: snapshot.data!["totalAltGain"],
                    ),
                    // Show the altitude graph
                    PostrunAltGraph(alts: snapshot.data!["alts"]),
                    // Show the map
                    const PostrunMaptext(),
                    PostrunMap(
                      lats: snapshot.data!["lats"], 
                      longs: snapshot.data!["longs"]
                    ),
                  ]
                )
              ),
            ],
          );
          
        }
      ),
    );
    
  }
}
