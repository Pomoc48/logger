import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';

class ListLeading extends StatelessWidget {
  const ListLeading({super.key, required this.number, required this.favorite});

  final int number;
  final bool favorite;

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
                color: favColor(favorite: favorite, context: context),
              ),
        ),
      ),
    );
  }
}
