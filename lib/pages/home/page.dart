import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/layouts/desktop.dart';
import 'package:logger_app/pages/home/layouts/mobile.dart';
import 'package:logger_app/pages/home/widgets/login_view.dart';
import 'package:logger_app/widgets/actions.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/fader.dart';
import 'package:logger_app/widgets/loading.dart';
import 'package:logger_app/pages/home/widgets/network_error.dart';
import 'package:logger_app/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeMessage) {
          showSnack(context, state.message);
        }
      },
      buildWhen: (previous, current) {
        if (current is HomeMessage) return false;
        if (current is RegisterResults) return false;
        return true;
      },
      builder: (context, state) {
        if (state is HomeLoaded) {
          if (state.tables.isEmpty) {
            return EmptyList(
              title: Strings.appName,
              state: state,
              press: () async => addNewTableDialog(
                context: context,
                token: state.token,
              ),
            );
          }

          return Fader(
            child: Scaffold(
              appBar: AppBar(
                title: Text(Strings.appName),
                actions: appBarActions(context, state),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async => addNewTableDialog(
                  context: context,
                  token: state.token,
                ),
                icon: const Icon(Icons.add),
                label: Text(Strings.newItemFAB),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return DesktopHome(
                      state: state,
                      width: constraints.maxWidth,
                    );
                  }

                  return MobileHome(state: state);
                }
              ),
            ),
          );
        }

        if (state is HomeLoginRequired) {
          return const LoginView();
        }

        if (state is HomeError) {
          return NetworkError(token: state.token);
        }

        return const PageLoading();
      },
    );
  }
}
