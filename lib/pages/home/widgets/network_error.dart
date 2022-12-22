import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/fader.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({super.key, required this.token});

  final String token;

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
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () async => refresh(
                  context: context,
                  token: token,
                ),
                icon: const Icon(Icons.refresh),
                label: Text(Strings.refresh),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
