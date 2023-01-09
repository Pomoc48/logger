import 'package:flutter/material.dart';

class ModalList extends StatelessWidget {
  const ModalList({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              Navigator.pop(context);
              onTap!();
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
