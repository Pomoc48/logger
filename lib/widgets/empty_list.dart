import 'package:flutter/material.dart';
import 'package:logger_app/strings.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key, required this.title, required this.press});

  final String title;
  final Future<void> Function() press;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => press(),
        icon: const Icon(Icons.add),
        label: Text(Strings.newItemFAB),
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
          const SizedBox(height: 56 + 32),
        ],
      ),
    );
  }
}
