import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  const DismissBackground({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData t = Theme.of(context);
    return Container(
      color: t.colorScheme.error,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.delete_forever, color: t.colorScheme.onError),
            const SizedBox(width: 16),
            Text(
              "Remove",
              style: t.textTheme.labelLarge!
                  .copyWith(color: t.colorScheme.onError),
            ),
          ],
        ),
      ),
    );
  }
}
