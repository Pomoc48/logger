// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_app/models/row.dart';
import 'package:logger_app/pages/list/bloc/functions.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';

Future<void> refresh(BuildContext context, String name) async {
  try {
    List serverConfig = GetStorage().read('serverConfig');
    List<RowItem> rowList = await getTableRows(serverConfig, name);
    
    context.read<ListBloc>().add(UpdateList(
      rowList: rowList,
      title: name,
      chartData: getChartData(rowList),
    ));

  } catch (e) {
    context.read<ListBloc>().add(ReportListError());
  }
}

Future<void> addNewRowDialog({
  required BuildContext context,
  required String name,
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

  context.read<ListBloc>().add(InsertList(
    timestamp: _dateToString(date, time),
    name: name,
  ));
}

String _dateToString(DateTime date, TimeOfDay time) {
  DateTime d = date.add(Duration(hours: time.hour, minutes: time.minute));
  return "${d.year}-${d.month}-${d.day} ${d.hour}:${d.minute}";
}
