
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/strings.dart';

Future<void> refresh(BuildContext context) async {
  try {
    List serverConfig = GetStorage().read('serverConfig');
    context.read<HomeBloc>().add(UpdateHome(await getTables(serverConfig)));
  } catch (e) {
    context.read<HomeBloc>().add(ReportHomeError());
  }
}

Future<void> addNewTableDialog(BuildContext context) async {
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
              context.read<HomeBloc>().add(
                InsertHome(controller.text),
              );
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

Future<bool> checkServerConnection({
  required String hostname,
  required String username,
  required String password,
  required String database,
}) async {
  Response response = await post(
    Uri.parse("https://lukawski.xyz/logs/test/?hostname=$hostname&username=$username&password=$password&database=$database"),
  );

  if (response.statusCode == 200) {
    return true;
  }

  return false;
}
