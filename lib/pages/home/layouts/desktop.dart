import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/actions.dart';
import 'package:logger_app/widgets/fader.dart';

class DesktopHome extends StatelessWidget {
  const DesktopHome({super.key, required this.state, required this.width});

  final HomeLoaded state;
  final double width;

  @override
  Widget build(BuildContext context) {
    double padding = width > 1200 ? 32 : 24;
    int axis = width > 1200 ? 3 : 2;

    TextTheme tTheme = Theme.of(context).textTheme;
    ColorScheme cScheme = Theme.of(context).colorScheme;

    return Fader(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.appName),
          automaticallyImplyLeading: false,
          actions: appBarActions(context, state),
        ),
        body: GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: axis,
            mainAxisExtent: 162,
            crossAxisSpacing: padding,
            mainAxisSpacing: padding,
          ),
          itemCount: state.lists.length + 1,
          itemBuilder: (context, i) {
            if (i == state.lists.length) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: cScheme.primary.withOpacity(0.25),
                    width: 2,
                  ),
                ),
                child: InkWell(
                  onTap: () async => addNewListDialog(
                    context: context,
                    token: state.token,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 8),
                      Text(
                        Strings.addNewCounter,
                        style: tTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cScheme.primary.withOpacity(0.25),
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () async {
                  BlocProvider.of<ListBloc>(context).add(LoadList(
                    list: state.lists[i],
                    token: state.token,
                  ));

                  await Navigator.pushNamed(context, Routes.list);
                  // ignore: use_build_context_synchronously
                  refresh(context: context, token: state.token);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70,
                        child: LineChart(data: state.lists[i].chartData),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => quickItemDialog(
                              context: context,
                              list: state.lists[i],
                              token: state.token,
                            ),
                            constraints: const BoxConstraints(
                              minHeight: 48,
                              minWidth: 48,
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.lists[i].name,
                                  style: tTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  subtitleCount(state.lists[i].count),
                                  style: tTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            color: cScheme.secondaryContainer,
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: "delete",
                                  child: Text(Strings.delete),
                                ),
                              ];
                            },
                            onSelected: (value) async {
                              if (value == "delete") {
                                bool delete = await confirmDismiss(
                                  context: context,
                                  message: Strings.areSure,
                                );

                                if (delete) {
                                  // ignore: use_build_context_synchronously
                                  BlocProvider.of<HomeBloc>(context).add(
                                    RemoveFromHome(
                                      id: state.lists[i].id,
                                      lists: state.lists,
                                      token: state.token,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
