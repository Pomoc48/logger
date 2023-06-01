import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';

class ListRemove extends StatelessWidget {
  const ListRemove({required this.itemId, super.key, required this.listId});

  final Key itemId;
  final Key listId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz),
      color: Theme.of(context).colorScheme.secondaryContainer,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: "delete",
            child: Text(Strings.delete),
          ),
        ];
      },
      onSelected: (value) {
        if (value == "delete") {
          BlocProvider.of<ListBloc>(context).add(
            RemoveListItem(
              itemId: itemId,
              listId: listId,
            ),
          );
        }
      },
    );
  }
}
