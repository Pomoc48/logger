import 'package:flutter/material.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({super.key, this.height = 0});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      endIndent: 16,
      indent: 16,
    );
  }
}
