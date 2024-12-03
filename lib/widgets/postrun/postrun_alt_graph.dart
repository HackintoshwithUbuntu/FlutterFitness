import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class PostrunAltGraph extends StatelessWidget {
  final List<int> alts;
  final List<FlSpot> altsData;

  PostrunAltGraph({super.key, required this.alts})
    // Dynamically generate graph data points
      : altsData = List.generate(alts.length, (index) {
          return FlSpot(index.toDouble(), alts[index].toDouble());
        });
      

  static const gradientColors = [Color.fromARGB(255, 26, 208, 253), Color.fromARGB(255, 33, 243, 156)];

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        // Manually override the position so text is more centered with graph
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text("Altitude Graph", textAlign: TextAlign.left, style: Theme.of(context).textTheme.titleMedium!,),
          ),
        ),
        // Constrain graph area
        AspectRatio(
          aspectRatio: 2,
          // Leave gaps so graph does not hit screen edges
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 5,
              top: 10,
              bottom: 14,
            ),
            // The actual graph
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
                // Hide redundant right, top and bottom axis
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                // Pass through points
                lineBarsData: [LineChartBarData(
                  spots: altsData,
                  // Curve graph but prevent it from exceeding bounds
                  isCurved: true,
                  preventCurveOverShooting: true,
                  // Create gradient
                  gradient: const LinearGradient(
                    colors: gradientColors,
                  ),
                  // Set width of line
                  barWidth: 5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: false,
                  ),
                  // Fill area underneath graph
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: gradientColors
                          .map((color) => color.withOpacity(0.3))
                          .toList(),
                    ),
                  ),
                )]
              )
            ),
          ),
        ),
      ],
    );
  }
}
