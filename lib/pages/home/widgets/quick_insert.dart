import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';

class QuickInsert extends StatelessWidget {
  const QuickInsert({super.key, required this.list, required this.token});

  final ListOfItems list;
  final String token;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => quickItemDialog(
        context: context,
        list: list,
        token: token,
      ),
      constraints: const BoxConstraints(
        minHeight: 48,
        minWidth: 48,
      ),
      icon: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

Future<void> quickItemDialog({
  required BuildContext context,
  required ListOfItems list,
  required String token,
}) async {
  DateTime date = DateTime.now();

  BlocProvider.of<HomeBloc>(context).add(
    QuickInsertHome(
      timestamp: dateToTimestamp(date),
      list: list,
      token: token,
    ),
  );
}
