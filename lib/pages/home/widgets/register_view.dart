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

    void register() {
      if (username.text == "" ||
          password.text == "" ||
          repeatP.text == "") {
        showSnack(context, Strings.allFields);
        return;
      }

      if (password.text != repeatP.text) {
        showSnack(context, Strings.passwordError);
        return;
      }

      BlocProvider.of<HomeBloc>(context).add(RequestRegister(
        username: username.text,
        password: password.text,
      ));
    }

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is RegisterResults) {
          showSnack(context, state.message);
          if (state.registered) Navigator.pop(context);
        }
      },
      child: Material(
        child: Fader(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
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
                            decoration: InputDecoration(
                              label: Text(Strings.username),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              label: Text(Strings.password),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: repeatP,
                            obscureText: true,
                            decoration: InputDecoration(
                              label: Text(Strings.passwordR),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: register,
                            child: Text(Strings.register),
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
                  onPressed: register,
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
                        decoration: InputDecoration(
                          label: Text(Strings.username),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text(Strings.password),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: repeatP,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text(Strings.passwordR),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
