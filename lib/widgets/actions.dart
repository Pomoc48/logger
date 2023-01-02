import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/pages/home/widgets/sorting.dart';

List<Widget> appBarActions(BuildContext context, HomeLoaded state) {
  return [
    Sorting(state: state),
    const SizedBox(width: 8),
    PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.secondaryContainer,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: "refresh",
            child: Text(Strings.refresh),
          ),
          PopupMenuItem<String>(
            value: "logout",
            child: Text(Strings.logout),
          ),
        ];
      },
      onSelected: (value) {
        if (value == "refresh") {
          refresh(
            context: context,
            token: state.token,
          );
        }

        if (value == "logout") {
          context.read<HomeBloc>().add(ReportLogout());
        }
      },
    ),
  ];
}
