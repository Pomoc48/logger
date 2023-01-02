// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/item.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/list/bloc/functions.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';

Future<void> refresh({
  required BuildContext context,
  required ListOfItems list,
  required String token,
}) async {
  try {
    Map map = await getItems(listId: list.id, token: token);
    var items = List<ListItem>.from(map["data"]);

    BlocProvider.of<ListBloc>(context).add(UpdateList(
      itemList: items,
      list: list,
      chartData: getChartData(items),
      token: map["token"],
    ));
  } catch (e) {
    BlocProvider.of<ListBloc>(context).add(ReportListError());
  }
}

Future<void> addNewItemDialog({
  required BuildContext context,
  required ListOfItems list,
  required String token,
}) async {
  DateTime dateNow = DateTime.now();

  DateTime? date = await showDatePicker(
    context: context,
    initialDate: dateNow,
    firstDate: DateTime(dateNow.year - 1),
    lastDate: dateNow,
  );

  if (date == null) return;

  TimeOfDay timeNow = TimeOfDay.now();

  TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: timeNow,
  );

  if (time == null) return;

  BlocProvider.of<ListBloc>(context).add(
    InsertList(
      timestamp: dateToTimestamp(date, time),
      list: list,
      token: token,
    ),
  );
}
