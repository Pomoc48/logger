// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/enums/list_sorting.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/divider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, this.desktop = false});
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    TextTheme tTheme = Theme.of(context).textTheme;
    ColorScheme cScheme = Theme.of(context).colorScheme;

    Widget listTile({
      required IconData iconData,
      required String label,
      required String value,
    }) {
      Color backgroundColor = Colors.transparent;

      TextStyle? drawerLabel(BuildContext context) {
        return tTheme.apply(bodyColor: cScheme.onSecondaryContainer).labelLarge;
      }

      List<Widget> drawItems() {
        return [
          const SizedBox(width: 16),
          Icon(
            iconData,
            color: cScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 16),
          Text(label, style: drawerLabel(context)),
        ];
      }

      Widget sortOption(BuildContext c, String name, SortingType value) {
        return InkWell(
          onTap: () {
            BlocProvider.of<HomeBloc>(c).add(ChangeSort(sortingType: value));
            Navigator.pop(c);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(name),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () async {
            if (!desktop) Navigator.pop(context);

            if (value == "sort") {
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
                            Strings.sortCounterAsc,
                            SortingType.countASC,
                          ),
                          sortOption(
                            context,
                            Strings.sortDateDesc,
                            SortingType.dateDESC,
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
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: backgroundColor,
            ),
            height: 56,
            child: Row(children: drawItems()),
          ),
        ),
      );
    }

    return Drawer(
      backgroundColor: desktop ? cScheme.surfaceTint.withOpacity(0.05) : null,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 24),
          listTile(
            iconData: Icons.sort,
            label: Strings.changeSorting,
            value: "sort",
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
