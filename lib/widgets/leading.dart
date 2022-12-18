import 'package:flutter/material.dart';

class ListLeading extends StatelessWidget {
  const ListLeading(this.number, {super.key});

  final int number;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 40),
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Text(
          number.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
