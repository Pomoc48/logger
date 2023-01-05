import 'package:flutter/material.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/fader.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);
    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.noConnection)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56),
              Text(Strings.error, style: t.textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(Strings.noNet, style: t.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
