import 'package:flutter/material.dart';

import 'package:runfun/widgets/run/stat_display.dart';

class StatTable extends StatelessWidget {
  final double indent;
  final String totalDistance;
  final String totalAltGain;
  final String totalSteps;
  final String cadence;

  const StatTable({
    super.key,
    required this.indent, 
    required this.totalDistance, 
    required this.totalAltGain,
    required this.totalSteps,
    required this.cadence,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      // Set column widths, leaving more space for stat values
      columnWidths: const {
        0: FractionColumnWidth(0.1),
        1: FractionColumnWidth(0.35),
        2: FractionColumnWidth(0.1),
        3: FractionColumnWidth(0.35),
        4: FractionColumnWidth(0.1),
      },
      children: [
        TableRow(
          children: <Widget>[
            // Show distance and steps stats
            // Container to fill empty spaces, recommended method for blank cell
            // https://github.com/flutter/flutter/issues/42523 
            Container(),
            StatDisplay(label: "Distance (km)", stat: totalDistance),
            Container(),
            StatDisplay(label: "Steps", stat: totalSteps),
            Container(),
          ]
        ),
        // Make a divider by willing every column with a divider
        TableRow(
          children: <Widget>[
            Divider(indent: indent),
            const Divider(),
            const Divider(),
            const Divider(),
            Divider(endIndent: indent),
          ]
        ),
        TableRow(
          children: <Widget>[
            // Show height gain and cadence 
            Container(),
            StatDisplay(label: "Height Gain (m)", stat: totalAltGain),
            Container(),
            StatDisplay(label: "Cadence", stat: cadence),
            Container(),
          ]
        )
      ],
    );
  }
}