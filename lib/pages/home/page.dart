import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/layouts/desktop.dart';
import 'package:logger_app/pages/home/layouts/mobile.dart';
import 'package:logger_app/pages/home/widgets/login_view.dart';
import 'package:logger_app/widgets/loading.dart';
import 'package:logger_app/pages/home/widgets/network_error.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool mobile = constraints.maxWidth < 600;
        
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
              if (mobile) return MobileHome(state: state);
              
              return DesktopHome(
                state: state,
                width: constraints.maxWidth,
              );
            }

            if (state is HomeLoginRequired) {
              return LoginView(mobile: mobile);
            }

            if (state is HomeError) {
              return NetworkError(token: state.token);
            }

            return const PageLoading();
          },
        );
      }
    );
  }
}
