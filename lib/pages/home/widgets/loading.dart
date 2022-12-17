import 'package:flutter/material.dart';
import 'package:log_app/strings.dart';

class PageLoading extends StatelessWidget {
  const PageLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.appName)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
