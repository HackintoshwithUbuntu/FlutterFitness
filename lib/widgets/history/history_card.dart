import 'package:flutter/material.dart';

import 'package:runfun/icons.dart';

import 'package:runfun/views/nav_views/history_run_view.dart';
import 'package:runfun/widgets/history/history_stat.dart';
import 'package:runfun/widgets/ui/custom_card.dart';

class HistoryCard extends StatelessWidget {
  final String date;
  final String type;
  final String fileName;
  final String steps;
  final String distance;
  final String time;
  const HistoryCard({
      super.key,
      required this.date,
      required this.type,
      required this.fileName,
      required this.steps,
      required this.distance,
      required this.time
    }
  );

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: historyCardInfo(context),
      // On tap push a page with data from the requested run
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HistoryRunView(
              fileName: fileName
            )),
          );
        },
    );
  }

  Widget historyCardInfo(BuildContext context){
    return Row(
      children: <Widget> [
        // Draw icon
        Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme.of(context).colorScheme.primaryContainer
          ),
          padding: const EdgeInsets.all(15),
          child: Icon(
            // Choose appropriate icon
            type == "Run" ? CustomIcons.run : CustomIcons.walk,
            size: 32,
          )
        ),
        // Show info beside the icon
        Column(
          children: [
            // Title text
            Text("$type at $date", style: const TextStyle(
                fontWeight: FontWeight.w500
              )
            ),
            // Little individual summary stats
            Row(children: [
              HistoryStat(icon: CustomIcons.ruler, value: "$distance km"),
              const SizedBox(height:0, width: 10),
              HistoryStat(icon: CustomIcons.stopwatch, value: time.substring(0,5)),
            ]),
            HistoryStat(icon: CustomIcons.googleSteps, value: steps),
          ],
        ),
      ],
    );
  }
}
