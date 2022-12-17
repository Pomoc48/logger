import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_app/pages/home/bloc/home_bloc.dart';
import 'package:log_app/pages/home/functions.dart';
import 'package:log_app/pages/home/widgets/empty_list.dart';
import 'package:log_app/pages/home/widgets/loading.dart';
import 'package:log_app/pages/home/widgets/network_error.dart';
import 'package:log_app/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {

        ThemeData t = Theme.of(context);

        if (state is HomeLoaded) {
          if (state.tables.isEmpty) return const EmptyList();

          return Scaffold(
            appBar: AppBar(title: Text(Strings.appName)),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => addNewTableDialog(context),
              icon: const Icon(Icons.add),
              label: Text(Strings.newLog),
            ),
            body: RefreshIndicator(
              onRefresh: () async => refresh(context),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(state.tables[index].name),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: t.colorScheme.error,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: t.colorScheme.onError,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              "Remove",
                              style: t.textTheme.labelLarge!
                                  .copyWith(color: t.colorScheme.onError),
                            ),
                          ],
                        ),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      bool dismiss = false;
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(Strings.confirmation),
                            content: Text(Strings.areSure),
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
                    },
                    onDismissed: (direction) {
                      context.read<HomeBloc>().add(RemoveFromHome(
                          state.tables[index], state.tables));
                    },
                    child: ListTile(
                      onTap: () {},
                      trailing: SizedBox(
                        width: 120,
                        height: 40,
                        child: Sparkline(
                          lineWidth: 2,
                          data: [1, 2, 2, 3, 4, 4, 5, 5, 5, 5, 6, 6, 7, 8],
                          lineGradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              t.colorScheme.primary.withOpacity(0.1),
                              t.colorScheme.primary,
                            ]
                          ),
                        ),
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

        if (state is HomeError) {
          return const NetworkError();
        }

        return const PageLoading();
      },
    );
  }
}
