import 'package:flutter/material.dart';
import 'package:logger_app/widgets/fader.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Text("WIP"),
        ),
      ),
    );
  }
}
