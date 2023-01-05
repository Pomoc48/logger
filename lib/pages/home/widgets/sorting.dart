import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';

class Sorting extends StatelessWidget {
  const Sorting({super.key, required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.filter_list, size: 20),
        const SizedBox(width: 8),
        DropdownButton(
          underline: const SizedBox(),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
          value: state.sort.name,
          onChanged: (value) async {
            await GetStorage().write("sortType", value);
            // ignore: use_build_context_synchronously
            BlocProvider.of<HomeBloc>(context).add(
              ChangeSort(state: state),
            );
          },
          items: [
            DropdownMenuItem(
              value: SortingType.count.name,
              child: Text(SortingType.count.name.capitalize()),
            ),
            DropdownMenuItem(
              value: SortingType.name.name,
              child: Text(SortingType.name.name.capitalize()),
            ),
            DropdownMenuItem(
              value: SortingType.date.name,
              child: Text(SortingType.date.name.capitalize()),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
