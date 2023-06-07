import 'package:flutter/material.dart';
import 'package:logger_app/strings.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
    required this.title,
    required this.press,
  });

  final String title;
  final Future<void> Function() press;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => press(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Strings.empty,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 56 + 32),
        ],
      ),
    );
  }
}
