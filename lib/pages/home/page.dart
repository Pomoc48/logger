import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_app/pages/home/bloc/home_bloc.dart';
import 'package:log_app/pages/home/functions.dart';
import 'package:log_app/pages/home/widgets/chart.dart';
import 'package:log_app/widgets/dismiss_background.dart';
import 'package:log_app/widgets/empty_list.dart';
import 'package:log_app/widgets/loading.dart';
import 'package:log_app/pages/home/widgets/network_error.dart';
import 'package:log_app/pages/home/widgets/server_setup.dart';
import 'package:log_app/pages/list/bloc/list_bloc.dart';
import 'package:log_app/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        ThemeData t = Theme.of(context);
    
        if (state is HomeLoaded) {
          if (state.tables.isEmpty) {
            return EmptyList(
              title: Strings.appName,
              press: () async => addNewTableDialog(context),
            );
          }
    
          return Scaffold(
            appBar: AppBar(title: Text(Strings.appName)),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async => addNewTableDialog(context),
              icon: const Icon(Icons.add),
              label: Text(Strings.newItemFAB),
            ),
            body: RefreshIndicator(
              onRefresh: () async => refresh(context),
              child: ListView.separated(
                separatorBuilder: (c, i) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  return Dismissible(
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
                      onTap: () {
                        context.read<ListBloc>().add(LoadList(
                            state.tables[index]));

                        Navigator.pushNamed(context, Routes.list);
                      },
                      trailing: SizedBox(
                        width: 120,
                        height: 40,
                        child: LineChart(data: state.tables[index].chartData),
                      ),
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: t.textTheme.titleLarge!.copyWith(
                              color: t.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(state.tables[index].name),
                      subtitle: Text("${state.tables[index].rows} items"),
                    ),
                  );
                },
                itemCount: state.tables.length,
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
    
        return PageLoading(title: Strings.appName);
      },
    );
  }
}

