// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/avatar.dart';
import 'package:logger_app/widgets/divider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    Widget listTile({
      required IconData iconData,
      required String label,
      required String value,
    }) {
      Color backgroundColor = Colors.transparent;

      TextStyle? drawerLabel(BuildContext context) {
        return Theme.of(context).textTheme.apply(
          bodyColor: Theme.of(context).colorScheme.onSecondaryContainer,
        ).labelLarge;
      }

      List<Widget> drawItems() {
        return [
          const SizedBox(width: 16),
          Icon(
            iconData,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 16),
          Text(label, style: drawerLabel(context)),
        ];
      }

      Widget sortOption(BuildContext c, String name, String value) {
        return InkWell(
          onTap: () async {
            await GetStorage().write("sortType", value);
            
            BlocProvider.of<HomeBloc>(c).add(ChangeSort(state: state));
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
            Navigator.pop(context);

            if (value == "refresh") {
              refresh(
                context: context,
                state: state,
              );
            }

            if (value == "connect") {
              TextEditingController controller = TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(Strings.connect),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(Strings.connectMessage),
                        TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text(Strings.pairingCode),
                            hintText: Strings.pairingHint,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(Strings.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            BlocProvider.of<HomeBloc>(context).add(
                              CheckPairingCode(
                                code: controller.text,
                                token: state.token,
                              ),
                            );

                            Navigator.pop(context);
                          }
                        },
                        child: Text(Strings.connect),
                      ),
                    ],
                  );
                },
              );
            }

            if (value == "sort") {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                    title: Text(Strings.changeSorting),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ListDivider(),
                        sortOption(
                          context,
                          Strings.sortName,
                          SortingType.name.name, 
                        ),
                        sortOption(
                          context,
                          Strings.sortDateAsc,
                          SortingType.dateASC.name, 
                        ),
                        sortOption(
                          context,
                          Strings.sortCounterAsc,
                          SortingType.countASC.name, 
                        ),
                        sortOption(
                          context,
                          Strings.sortDateDesc,
                          SortingType.dateDESC.name, 
                        ),
                        sortOption(
                          context,
                          Strings.sortCounterDesc,
                          SortingType.countDESC.name, 
                        ),
                        const ListDivider(),
                      ],
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

            if (value == "logout") {
              context.read<HomeBloc>().add(ReportLogout());
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: backgroundColor,
            ),
            height: 48,
            child: Row(children: drawItems()),
          ),
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Row(
              children: [
                Avatar(profileUrl: state.profileUrl, size: 48),
                const SizedBox(width: 18),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.username,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${listCount(state.lists.length)} • ${countItems(state.lists)}",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 16, indent: 16, endIndent: 16),
          const SizedBox(height: 12),
          listTile(
            iconData: Icons.refresh,
            label: Strings.refresh,
            value: "refresh",
          ),
          listTile(
            iconData: Icons.people_alt,
            label: Strings.friends,
            value: "friends",
          ),
          listTile(
            iconData: Icons.sort,
            label: Strings.changeSorting,
            value: "sort",
          ),
          listTile(
            iconData: Icons.watch,
            label: Strings.connectWearable,
            value: "connect",
          ),
          listTile(
            iconData: Icons.logout,
            label: Strings.logout,
            value: "logout",
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

String listCount(int count) {
  return count == 1 ? "$count counter" : "$count counters";
}

String countItems(List<ListOfItems> lists) {
  int itemCount = 0;

  for (ListOfItems list in lists) {
    itemCount += list.count;
  }

  return "$itemCount total";
}