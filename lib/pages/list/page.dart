import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/pages/list/layouts/desktop.dart';
import 'package:logger_app/pages/list/layouts/mobile.dart';
import 'package:logger_app/widgets/loading.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool mobile = constraints.maxWidth < 600;

        return BlocConsumer<ListBloc, ListState>(
          listener: (context, state) {
            if (state is ListMessage) {
              showSnack(context, state.message);
            }

            if (state is ListError) {
              Navigator.pop(context);
            }
          },
          buildWhen: (previous, current) {
            if (current is ListMessage) return false;
            return true;
          },
          builder: (context, state) {
            if (state is ListLoaded) {
              if (mobile) return MobileList(state: state);

              return DesktopList(state: state, width: constraints.maxWidth);
            }

            if (state is ListInitial) {
              return const PageLoading();
            }

            return const PageLoading();
          },
        );
      }
    );
  }
}
