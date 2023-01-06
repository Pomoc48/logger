import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';

class ListRemove extends StatelessWidget {
  const ListRemove({required this.index, required this.state, super.key});

  final int index;
  final ListLoaded state;

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
            RemoveFromList(
              item: state.itemList[index],
              list: state.list,
              token: state.token,
            ),
          );
        }
      },
    );
  }
}
