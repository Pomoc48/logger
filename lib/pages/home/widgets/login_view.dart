import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/fader.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();

    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.login)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (username.text == "" || password.text == "") {
              showSnack(context, Strings.allFields);
              return;
            }

            BlocProvider.of<HomeBloc>(context).add(RequestLogin(
              username: username.text,
              password: password.text,
            ));
          },
          icon: const Icon(Icons.login),
          label: Text(Strings.login),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: username,
                decoration: InputDecoration(label: Text(Strings.username)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(label: Text(Strings.password)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, Routes.register),
                child: Text(Strings.createUser),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
