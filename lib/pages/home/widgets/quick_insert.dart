import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';

class QuickInsert extends StatelessWidget {
  const QuickInsert({super.key, required this.list, required this.state});

  final ListOfItems list;
  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => quickItem(
        context: context,
        list: list,
        state: state,
      ),
      constraints: const BoxConstraints(
        minHeight: 48,
        minWidth: 48,
      ),
      icon: Icon(
        Icons.bolt,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

Future<void> quickItem({
  required BuildContext context,
  required ListOfItems list,
  required HomeLoaded state,
}) async {
  DateTime date = DateTime.now();

  BlocProvider.of<HomeBloc>(context).add(
    QuickInsertHome(
      timestamp: dateToTimestamp(date),
      list: list,
      state: state,
    ),
  );
}
