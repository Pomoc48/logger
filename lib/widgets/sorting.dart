import 'package:flutter/material.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';

class Sorting extends StatefulWidget {
  const Sorting({super.key});

  @override
  State<Sorting> createState() => _SortingState();
}

class _SortingState extends State<Sorting> {

  int dropdownValue = SortingType.count.index;

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
          value: dropdownValue,
          onChanged: (value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          items: [
            DropdownMenuItem(
              value: SortingType.count.index,
              child: Text(SortingType.count.name.capitalize()),
            ),
            DropdownMenuItem(
              value: SortingType.name.index,
              child: Text(SortingType.name.name.capitalize()),
            ),
            DropdownMenuItem(
              value: SortingType.date.index,
              child: Text(SortingType.date.name.capitalize()),
            ),
          ],
          
        ),
      ],
    );
  }
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}
