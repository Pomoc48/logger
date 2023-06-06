import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/bloc/list_bloc.dart';
import 'package:logger_app/enums/list_sorting.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/divider.dart';

Future<void> addNewListDialog({required BuildContext context}) async {
  TextEditingController controller = TextEditingController();

  void confirm() {
    if (controller.text.trim().isNotEmpty) {
      BlocProvider.of<ListBloc>(context).add(InsertList(
        name: controller.text.trim(),
      ));

      Navigator.pop(context);
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Strings.newItem),
        content: SizedBox(
          width: 400,
          child: TextField(
            autofocus: true,
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              label: Text(Strings.counterName),
              hintText: Strings.newListHint,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => confirm(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () => confirm(),
            child: Text(Strings.create),
          ),
        ],
      );
    },
  );
}

Future<bool> confirmDelete({
  required BuildContext context,
  required String message,
}) async {
  bool dismiss = false;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Strings.confirmation),
        content: SizedBox(
          width: 400,
          child: Text(message),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: Text(Strings.cancel),
          ),
          TextButton.icon(
            onPressed: () {
              dismiss = true;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outlined),
            label: Text(Strings.delete),
          ),
        ],
      );
    },
  );

  return dismiss;
}

Future<void> renameDialog({
  required BuildContext context,
  required Key listId,
  required String oldName,
}) async {
  TextEditingController controller = TextEditingController();
  controller.text = oldName;

  void confirm(BuildContext c) async {
    if (controller.text.trim().isNotEmpty) {
      Navigator.pop(c);

      // await updateListName(
      //   id: counterId,
      //   name: controller.text,
      //   token: state.token,
      // );
    }
  }

  await showDialog(
    context: context,
    builder: (c) {
      return AlertDialog(
        title: Text(Strings.changeName),
        content: SizedBox(
          width: 400,
          child: TextField(
            autofocus: true,
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              label: Text(Strings.counterName),
              hintText: Strings.newListHint,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => confirm(c),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () async => confirm(c),
            child: Text(Strings.rename),
          ),
        ],
      );
    },
  );
}

String subtitleCount(int count) {
  return count == 1 ? "$count time" : "$count times";
}

void showSortingOptions(BuildContext context) {
  Widget sortOption(BuildContext c, String name, SortingType value) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ListBloc>(c).add(ChangeSort(sortingType: value));
        Navigator.pop(c);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(name),
      ),
    );
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
        title: Text(Strings.changeSorting),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ListDivider(),
              sortOption(
                context,
                Strings.sortName,
                SortingType.name,
              ),
              sortOption(
                context,
                Strings.sortDateAsc,
                SortingType.dateASC,
              ),
              sortOption(
                context,
                Strings.sortDateDesc,
                SortingType.dateDESC,
              ),
              sortOption(
                context,
                Strings.sortCounterAsc,
                SortingType.countASC,
              ),
              sortOption(
                context,
                Strings.sortCounterDesc,
                SortingType.countDESC,
              ),
              const ListDivider(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Strings.cancel),
          ),
        ],
      );
    },
  );
}
