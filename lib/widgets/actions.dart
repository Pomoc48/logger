import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/strings.dart';

List<Widget> appBarActions(BuildContext context) {
  return [
    PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: "logout",
            child: Row(
              children: [
                const Icon(Icons.logout),
                const SizedBox(width: 8),
                Text(Strings.logout),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) {
        if (value == "logout") {
          context.read<HomeBloc>().add(ReportLogout());
        }
      },
    ),
  ];
}
