import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class Fader extends StatelessWidget {
  const Fader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: FadeIn(
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }
}
