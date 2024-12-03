import 'package:flutter/material.dart';

class LeaderboardCard extends StatelessWidget {
  final List<dynamic> data;
  final String header;
  const LeaderboardCard({super.key, required this.data, required this.header});

  TextStyle boardStyle() {
    return const TextStyle(fontSize: 16);
  }

  TextStyle headerStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Table(
            // Set column widths
            columnWidths: const {
              0: FractionColumnWidth(0.2),
              1: FractionColumnWidth(0.6),
              2: FractionColumnWidth(0.2),
            },
            children: [
              // Draw a header row
              TableRow(
                children: [
                  Center(child: Text("Rank", style: headerStyle())),
                  Text("Username", style: headerStyle()),
                  Text(header, style: headerStyle()),
                ]
              ),
              // Iterate through the rows of data
              for (final List<dynamic> i in data)
              TableRow(
                children: [
                  Center(child: Text(i[0].toString(), style: boardStyle())),
                  Text(i[1], style: boardStyle()),
                  Text(i[2].toString(), style: boardStyle()),
                ]
              )
            ]
          ),
        ),
      ),
    );
  }
}
