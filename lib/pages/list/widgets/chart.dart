import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  const LineChart({required this.data, super.key});

  final List<double> data;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Sparkline(
        lineWidth: 2,
        data: data,
        lineGradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.primary,
          ],
        ),
        fillGradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.0),
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ]
        ),
        fillMode: FillMode.below,
      ),
    );
  }
}
