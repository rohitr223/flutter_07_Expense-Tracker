import 'package:expense_tracker_app/barGraph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thursAmount;
  final double friAmount;
  final double satAmount;

  const BarGraph({
    super.key,
    required this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thursAmount,
    required this.friAmount,
    required this.satAmount,
  });

  @override
  Widget build(BuildContext context) {
    // initialize the bar data
    BarData myBarData = BarData(
      sunAmount: sunAmount,
      monAmount: monAmount,
      tueAmount: tueAmount,
      wedAmount: wedAmount,
      thursAmount: thursAmount,
      friAmount: friAmount,
      satAmount: satAmount,
    );

    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        gridData: const FlGridData(show: false), // remove grid lines
        borderData: FlBorderData(show: false), // remove all border lines
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTiles,
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    width: 20,
                    color: const Color.fromARGB(255, 88, 77, 218),
                    borderRadius: BorderRadius.circular(3),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomTiles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromARGB(255, 191, 188, 188),
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  Widget text;

  switch (value.toInt()) {
    case 0:
      text = const Text('Sun', style: style);
    case 1:
      text = const Text('Mon', style: style);
    case 2:
      text = const Text('Tue', style: style);
    case 3:
      text = const Text('Wed', style: style);
    case 4:
      text = const Text('Thu', style: style);
    case 5:
      text = const Text('Fri', style: style);
    case 6:
      text = const Text('Sat', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
