import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';

class LineChart extends StatelessWidget {
  const LineChart({required this.data, required this.favorite, super.key});

  final List<double> data;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    Color color = favColor(favorite: favorite, context: context);

    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Sparkline(
        lineWidth: 2,
        data: data,
        lineGradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            color.withOpacity(0.5),
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
      ),
    );
  }
}
