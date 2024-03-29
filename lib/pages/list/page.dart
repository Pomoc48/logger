import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/bloc/list_bloc.dart';
import 'package:logger_app/pages/list/layouts/desktop.dart';
import 'package:logger_app/pages/list/layouts/mobile.dart';
import 'package:logger_app/widgets/loading.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.id});

  final Key id;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool mobile = constraints.maxWidth < 600;

        return BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            if (state is ListLoaded) {
              ListOfItems list = state.lists.singleWhere(
                (list) => list.id == id,
              );

              if (mobile) return MobileList(list: list);
              return DesktopList(list: list, width: constraints.maxWidth);
            }

            return const PageLoading();
          },
        );
      },
    );
  }
}
