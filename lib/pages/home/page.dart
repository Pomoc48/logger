import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/widgets/dismiss_background.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/fader.dart';
import 'package:logger_app/widgets/loading.dart';
import 'package:logger_app/pages/home/widgets/network_error.dart';
import 'package:logger_app/pages/home/widgets/server_setup.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          if (state.tables.isEmpty) {
            return EmptyList(
              title: Strings.appName,
              press: () async => addNewTableDialog(context),
            );
          }

          return Fader(
            child: Scaffold(
              appBar: AppBar(title: Text(Strings.appName)),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async => addNewTableDialog(context),
                icon: const Icon(Icons.add),
                label: Text(Strings.newItemFAB),
              ),
              body: RefreshIndicator(
                onRefresh: () async => refresh(context),
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
                          context.read<HomeBloc>().add(RemoveFromHome(
                              state.tables[index], state.tables));
                        },
                        child: ListTile(
                          onTap: () async {
                            context
                                .read<ListBloc>()
                                .add(LoadList(state.tables[index]));

                            await Navigator.pushNamed(context, Routes.list);
                            // ignore: use_build_context_synchronously
                            refresh(context);
                          },
                          trailing: SizedBox(
                            width: 120,
                            height: 28,
                            child: LineChart(
                              data: state.tables[index].chartData,
                            ),
                          ),
                          title: Text(state.tables[index].name),
                          subtitle: Text(
                            rows == 1
                                ? "$rows time"
                                : rows == 0
                                    ? "List empty"
                                    : "$rows times",
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: state.tables.length,
                ),
              ),
            ),
          );
        }

        if (state is HomeServerSetup) {
          return const ServerSetup();
        }

        if (state is HomeError) {
          return const NetworkError();
        }

        return const PageLoading();
      },
    );
  }
}
