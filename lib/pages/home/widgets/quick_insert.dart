import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';

class QuickInsert extends StatelessWidget {
  const QuickInsert({
    super.key,
    required this.listId,
    required this.favorite,
  });

  final Key listId;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => quickItem(
        context: context,
        listId: listId,
      ),
      constraints: const BoxConstraints(
        minHeight: 48,
        minWidth: 48,
      ),
      icon: Icon(
        Icons.bolt,
        color: favColor(
          favorite: favorite,
          context: context,
        ),
      ),
    );
  }
}

Future<void> quickItem({
  required BuildContext context,
  required Key listId,
}) async {
  DateTime date = DateTime.now();

  BlocProvider.of<HomeBloc>(context).add(
    QuickInsertHome(
      date: date,
      listId: listId,
    ),
  );
}
