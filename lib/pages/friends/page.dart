import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/friends/bloc/friends_bloc.dart';
import 'package:logger_app/pages/friends/layouts/mobile.dart';
import 'package:logger_app/widgets/loading.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool mobile = constraints.maxWidth < 600;

        return BlocConsumer<FriendsBloc, FriendsState>(
          listener: (context, state) {
            if (state is FriendsMessage) {
              showSnack(context, state.message, mobile);
            }

            if (state is FriendsError) {
              Navigator.pop(context);
            }
          },
          buildWhen: (previous, current) {
            if (current is FriendsMessage) return false;
            return true;
          },
          builder: (context, state) {
            if (state is FriendsLoaded) {
              if (mobile) return MobileFriends(state: state);

              // return DesktopHome(
              //   state: state,
              //   width: constraints.maxWidth,
              // );
              return const PageLoading();
            }

            return const PageLoading();
          },
        );
      },
    );
  }
}
