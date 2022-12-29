import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/strings.dart';

Future<void> refresh({
  required BuildContext context,
  required String token,
}) async {
  try {
    Map map = await getLists(token: token);
    // ignore: use_build_context_synchronously
    BlocProvider.of<HomeBloc>(context).add(UpdateHome(
      lists: List<ListOfItems>.from(map["data"]),
      token: map["token"],
    ));
  } catch (e) {
    BlocProvider.of<HomeBloc>(context).add(ReportHomeError(token));
  }
}

Future<void> addNewTableDialog({
  required BuildContext context,
  required String token,
}) async {
  TextEditingController controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Strings.newItemFAB),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            label: Text(Strings.listName),
            hintText: Strings.newListHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(InsertHome(
                name: controller.text,
                token: token,
              ));

              Navigator.pop(context);
            },
            child: Text(Strings.create),
          ),
        ],
      );
    },
  );
}

Future<bool> confirmDismiss({
  required BuildContext context,
  required String message,
}) async {
  bool dismiss = false;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Strings.confirmation),
        content: Text(message),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: Text(Strings.cancel),
          ),
          TextButton.icon(
            onPressed: () {
              dismiss = true;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outlined),
            label: Text(Strings.delete),
          ),
        ],
      );
    },
  );

  return dismiss;
}

String subtitleCount(int rows) {
  return rows == 1
      ? "$rows time"
      : rows == 0
          ? "List empty"
          : "$rows times";
}
