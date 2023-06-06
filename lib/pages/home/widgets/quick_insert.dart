import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/bloc/list_bloc.dart';

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

  BlocProvider.of<ListBloc>(context).add(
    InsertListItem(
      date: date,
      listId: listId,
    ),
  );
}
