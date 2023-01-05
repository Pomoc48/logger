import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.profileUrl, this.size = 40});

  final String? profileUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (profileUrl is String) {
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
            ) => _missing(),
          ),
        ),
      );
    }

    return _missing();
  }

  Widget _missing() {
    return Icon(Icons.account_circle, size: size);
  }
}
