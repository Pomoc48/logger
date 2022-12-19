import 'package:flutter/material.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      endIndent: 16,
      indent: 16,
    );
  }
}
