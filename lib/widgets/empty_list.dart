import 'package:flutter/material.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/actions.dart';
import 'package:logger_app/widgets/fader.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
    required this.title,
    required this.press,
    this.disableActions = false,
  });

  final String title;
  final Future<void> Function() press;
  final bool disableActions;

  @override
  Widget build(BuildContext context) {
    return Fader(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: disableActions? null : appBarActions(context),
        ),
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
      ),
    );
  }
}
