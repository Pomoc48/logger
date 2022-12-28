import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/dismiss_background.dart';
import 'package:logger_app/widgets/divider.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key, required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => refresh(
        context: context,
        token: state.token,
      ),
      child: ListView.separated(
        separatorBuilder: (c, i) => const ListDivider(),
        itemBuilder: (context, index) {
          int rows = state.tables[index].rows;

          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 8 : 0,
              bottom: index == state.tables.length - 1 ? 88 : 0,
            ),
            child: Dismissible(
              key: Key(state.tables[index].name),
              direction: DismissDirection.startToEnd,
              background: const DismissBackground(),
              confirmDismiss: (d) async => confirmDismiss(
                context: context,
                message: Strings.areSure,
              ),
              onDismissed: (direction) {
                BlocProvider.of<HomeBloc>(context).add(
                  RemoveFromHome(
                    table: state.tables[index],
                    tableList: state.tables,
                    token: state.token,
                  ),
                );
              },
              child: SizedBox(
                height: 64 + 8,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 16, right: 16, top: 4,
                  ),
                  onTap: () async {
                    BlocProvider.of<ListBloc>(context).add(LoadList(
                      table: state.tables[index],
                      token: state.token,
                    ));

                    await Navigator.pushNamed(context, Routes.list);
                    // ignore: use_build_context_synchronously
                    refresh(context: context, token: state.token);
                  },
                  trailing: SizedBox(
                    width: 120,
                    height: 28,
                    child: LineChart(
                      data: state.tables[index].chartData,
                    ),
                  ),
                  title: Text(
                    state.tables[index].name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    rows == 1
                        ? "$rows time"
                        : rows == 0
                            ? "List empty"
                            : "$rows times",
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: state.tables.length,
      ),
    );
  }
}
