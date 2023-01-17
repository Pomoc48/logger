import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.profileUrl,
    this.size = 40,
    this.update = false,
  });

  final String? profileUrl;
  final double size;
  final bool update;

  @override
  Widget build(BuildContext context) {
    Widget child = (profileUrl is String) ? _content() : _missing();

    if (update) {
      return InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(999),
        child: child,
      );
    }

    return child;
  }

  ClipRRect _content() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: size,
        width: size,
        child: Image.network(
          profileUrl!,
          errorBuilder: (
            BuildContext context,
            Object exception,
            StackTrace? stackTrace,
          ) =>
              _missing(),
        ),
      ),
    );
  }

  Widget _missing() {
    return Icon(Icons.account_circle, size: size);
  }
}
