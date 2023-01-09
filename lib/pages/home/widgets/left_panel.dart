import 'package:flutter/material.dart';
import 'package:logger_app/widgets/fader.dart';

class DesktopPanel extends StatelessWidget {
  const DesktopPanel({
    super.key,
    required this.right,
    required this.left,
  });

  final Widget right;
  final Widget left;

  @override
  Widget build(BuildContext context) {
    return Fader(
      child: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 300,
              child: left,
            ),
            Expanded(child: right),
          ],
        ),
      ),
    );
  }
}
