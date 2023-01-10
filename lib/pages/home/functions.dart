import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/strings.dart';

Future<void> refresh({
  required BuildContext context,
  required HomeLoaded state,
}) async {
  try {
    Map map = await getLists(token: state.token);
    List<ListOfItems> list = List<ListOfItems>.from(map["data"]);
    sortList(list);
    // ignore: use_build_context_synchronously
    BlocProvider.of<HomeBloc>(context).add(UpdateHome(
      profileUrl: state.profileUrl,
      username: state.username,
      lists: list,
      token: map["token"],
    ));
  } catch (e) {
    BlocProvider.of<HomeBloc>(context).add(ReportHomeError(state.token));
  }
}

Future<void> addNewListDialog({
  required BuildContext context,
  required HomeLoaded state,
}) async {
  TextEditingController controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Strings.newItemFAB),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            label: Text(Strings.counterName),
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
              if (controller.text.trim().isNotEmpty) {
                BlocProvider.of<HomeBloc>(context).add(InsertHome(
                  name: controller.text,
                  state: state,
                ));

                Navigator.pop(context);
              }
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

Future<void> renameDialog({
  required BuildContext context,
  required int counterId,
  required HomeLoaded state,
}) async {
  TextEditingController controller = TextEditingController();
  await showDialog(
    context: context,
    builder: (c) {
      return AlertDialog(
        title: Text(Strings.changeName),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            label: Text(Strings.counterName),
            hintText: Strings.newListHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(c);

                await updateList(
                  id: counterId,
                  name: controller.text,
                  token: state.token,
                );

                await refresh(context: context, state: state);
              }
            },
            child: Text(Strings.rename),
          ),
        ],
      );
    },
  );
}

String subtitleCount(int count) {
  return count == 1 ? "$count time" : "$count times";
}
