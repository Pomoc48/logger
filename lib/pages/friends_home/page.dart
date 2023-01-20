import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/friends_home/bloc/friends_home_bloc.dart';
import 'package:logger_app/pages/friends_home/layouts/desktop.dart';
import 'package:logger_app/pages/friends_home/layouts/mobile.dart';
import 'package:logger_app/widgets/loading.dart';

class FriendsHomePage extends StatelessWidget {
  const FriendsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool mobile = constraints.maxWidth < 600;

        return BlocConsumer<FriendsHomeBloc, FriendsHomeState>(
          listener: (context, state) {
            if (state is FriendsHomeError) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is FriendsHomeLoaded) {
              if (mobile) return MobileFriendsHome(state: state);

              return DesktopFriendsHome(
                state: state,
                width: constraints.maxWidth,
              );
            }

            return const PageLoading();
          },
        );
      },
    );
  }
}
