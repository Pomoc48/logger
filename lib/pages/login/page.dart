import 'package:flutter/material.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/fader.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.login)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.login),
          label: Text(Strings.login),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  label: Text(Strings.username),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(Strings.password),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: Text(Strings.createUser),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
