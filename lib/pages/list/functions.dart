// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/bloc/list_bloc.dart';

Future<void> addNewItemDialog({
  required BuildContext context,
  required ListOfItems list,
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
    InsertListItem(
      date: date.add(Duration(hours: time.hour, minutes: time.minute)),
      listId: list.id,
    ),
  );
}
