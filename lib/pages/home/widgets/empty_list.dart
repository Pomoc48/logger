import 'package:flutter/material.dart';
import 'package:log_app/pages/home/functions.dart';
import 'package:log_app/strings.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.appName)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addNewTableDialog(context),
        icon: const Icon(Icons.add),
        label: Text(Strings.newLog),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.error_outline,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            Strings.empty,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 56+32),
        ],
      ),
    );
  }
}
