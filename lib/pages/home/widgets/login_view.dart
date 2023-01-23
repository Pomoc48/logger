import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/strings.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();

    void login() {
      if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
        showSnack(context, Strings.allFields, mobile);
        return;
      }

      BlocProvider.of<HomeBloc>(context).add(RequestLogin(
        username: username.text,
        password: password.text,
      ));
    }

    if (mobile) {
      return Scaffold(
        appBar: AppBar(title: Text(Strings.login)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: login,
          icon: const Icon(Icons.login),
          label: Text(Strings.login),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                controller: username,
                decoration: InputDecoration(
                  label: Text(Strings.username),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(Strings.password),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => login(),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.register,
                ),
                child: Text(Strings.createUser),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: username,
                decoration: InputDecoration(
                  label: Text(Strings.username),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(Strings.password),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => login(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: login,
                child: Text(Strings.login),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.register,
                ),
                child: Text(Strings.createUser),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
