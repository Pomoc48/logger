import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_app/pages/home/bloc/home_bloc.dart';
import 'package:log_app/pages/home/functions.dart';
import 'package:log_app/strings.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);
    return Scaffold(
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
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () async => refresh(context),
                  icon: const Icon(Icons.refresh),
                  label: Text(Strings.refresh),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(ReportServerUpdate());
                  },
                  child: Text(Strings.updatePassword),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
