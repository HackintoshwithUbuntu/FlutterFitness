import 'package:flutter/material.dart';

import 'package:runfun/widgets/ui/custom_appbar.dart';
import 'package:runfun/widgets/postrun/postrun_alt_graph.dart';
import 'package:runfun/widgets/postrun/postrun_initial_info.dart';
import 'package:runfun/widgets/postrun/postrun_map.dart';
import 'package:runfun/widgets/postrun/postrun_maptext.dart';
import 'package:runfun/widgets/postrun/postrun_stat_table.dart';

import 'package:runfun/run_notifier.dart';
import 'package:provider/provider.dart';

class Postrun extends StatefulWidget {
  const Postrun({super.key});

  @override
  State<Postrun> createState() => _PostrunState();
}

class _PostrunState extends State<Postrun> {
  @override
  void initState() {
    super.initState();
    final RunNotifier notifier =
      Provider.of<RunNotifier>(context, listen: false);
    notifier.onRunFinish();
  }

  @override
  Widget build(BuildContext context) {
    RunNotifier notifier = Provider.of<RunNotifier>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          CustomSliverAppBar(
            title: Text(
              "${notifier.exerciseType} Finished", 
              style: Theme.of(context).textTheme.titleLarge!
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              <Widget>[
                // Show Distance, Start time and End time
                PostrunInitialInfo(
                  totalDistance: notifier.totalDistance,
                  startEndTimeString: notifier.startEndTimeString,
                  isCheating: notifier.isCheating,
                ), 
                // Show the main stats
                PostrunStatTable(
                  timeString: notifier.timeString,
                  totalSteps: notifier.totalSteps,
                  avgSpeed: notifier.avgSpeed,
                  timePerKm: notifier.timePerKm,
                  stepsPerKm: notifier.stepsPerKm,
                  cadence: notifier.cadence,
                  totalAltGain: notifier.totalAltGain,
                ),
                PostrunAltGraph(alts: notifier.alts),
                const PostrunMaptext(),
                PostrunMap(
                  lats: notifier.lats, 
                  longs: notifier.longs
                ),
                SizedBox(
                  width: 200,
                  // Center ensures that button respects given size
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Center(
                      child: FilledButton(
                        child: Text("Finish ${notifier.exerciseType}"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                )
              ]
            )
          ),
        ],
      ),
    );
  }
}
