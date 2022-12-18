import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:log_app/pages/list/bloc/functions.dart';
import 'package:log_app/pages/list/bloc/list_bloc.dart';

Future<void> refresh(BuildContext context, String name) async {
  try {
    List serverConfig = GetStorage().read('serverConfig');
    context.read<ListBloc>().add(UpdateList(
      rowList: await getTableRows(serverConfig, name),
      title: name,
    ));

  } catch (e) {
    context.read<ListBloc>().add(ReportListError());
  }
}

Future<void> addNewRowDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("WIP"),
      );
    },
  );
}
