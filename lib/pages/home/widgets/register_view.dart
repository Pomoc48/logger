import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/fader.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController repeatP = TextEditingController();

    void register(bool mobile) {
      if (username.text.trim().isEmpty ||
          password.text.trim().isEmpty ||
          repeatP.text.trim().isEmpty) {
        showSnack(context, Strings.allFields, mobile);
        return;
      }

      if (password.text != repeatP.text) {
        showSnack(context, Strings.passwordError, mobile);
        return;
      }

      BlocProvider.of<HomeBloc>(context).add(RequestRegister(
        username: username.text,
        password: password.text,
      ));
    }

    Widget getLayout(bool mobile) {
      if (!mobile) {
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
                  TextField(
                    controller: repeatP,
                    obscureText: true,
                    decoration: InputDecoration(label: Text(Strings.passwordR)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => register(mobile),
                    child: Text(Strings.register),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<HomeBloc>(context).add(ReportLogout());
                      Navigator.pushReplacementNamed(context, Routes.home);
                    },
                    child: Text(Strings.haveAccount),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(title: Text(Strings.register)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => register(mobile),
          icon: const Icon(Icons.person_add),
          label: Text(Strings.register),
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
              TextField(
                controller: repeatP,
                obscureText: true,
                decoration: InputDecoration(label: Text(Strings.passwordR)),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool mobile = constraints.maxWidth < 600;

        return BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is RegisterResults) {
              showSnack(context, state.message, mobile);
              if (state.registered) {
                BlocProvider.of<HomeBloc>(context).add(ReportLogout());
                Navigator.pushReplacementNamed(context, Routes.home);
              }
            }
          },
          child: Fader(child: getLayout(mobile)),
        );
      },
    );
  }
}
