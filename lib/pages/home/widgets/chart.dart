import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';

class LineChart extends StatelessWidget {
  const LineChart({required this.data, required this.favorite, super.key});

  final List<int> data;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    List<double> dataConverted = [];

    for (int i in data) {
      dataConverted.add(i.toDouble());
    }

    Color color = favColor(favorite: favorite, context: context);

    return Sparkline(
      lineWidth: 2,
      data: dataConverted,
      lineGradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          color.withOpacity(0.1),
          color,
        ],
      ),
      fillGradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.2),
        ],
      ),
      fillMode: FillMode.below,
    );
  }
}
