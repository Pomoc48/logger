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
            value: "connect",
            child: Text(Strings.connect),
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

        if (value == "connect") {
          TextEditingController controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(Strings.connect),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Strings.connectMessage),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        label: Text(Strings.pairingCode),
                        hintText: Strings.pairingHint,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(Strings.cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        // BlocProvider.of<HomeBloc>(context).add(InsertHome(
                        //   name: controller.text,
                        //   token: token,
                        // ));

                        Navigator.pop(context);
                      }
                    },
                    child: Text(Strings.connect),
                  ),
                ],
              );
            },
          );
        }

        if (value == "logout") {
          context.read<HomeBloc>().add(ReportLogout());
        }
      },
    ),
  ];
}
