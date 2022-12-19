import 'package:flutter/material.dart';
import 'package:logger_app/widgets/fader.dart';

class PageLoading extends StatelessWidget {
  const PageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Fader(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
