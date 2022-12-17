import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_app/pages/home/bloc/functions.dart';
import 'package:log_app/pages/home/bloc/home_bloc.dart';
import 'package:log_app/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {

        refresh() async {
          try {
            context.read<HomeBloc>().add(UpdateHome(await getTables()));
          } catch (e) {
            context.read<HomeBloc>().add(ReportHomeError());
          }
        }

        ThemeData t = Theme.of(context);

        if (state is HomeLoaded) {
          if (state.tables.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: Text(Strings.appName)),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => Navigator.pushNamed(context, Routes.add),
                icon: const Icon(Icons.add),
                label: Text(Strings.newLog),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 56,
                    color: t.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Strings.empty,
                    textAlign: TextAlign.center,
                    style: t.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 56+32),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text(Strings.appName)),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                TextEditingController controller = TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(Strings.newLog),
                      content: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          label: Text(Strings.name),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(Strings.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(
                              InsertHome(controller.text),
                            );
                            Navigator.pop(context);
                          },
                          child: Text(Strings.create),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: Text(Strings.newLog),
            ),
            body: RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
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
                    onDismissed: (direction) {
                      context.read<HomeBloc>().add(RemoveFromHome(
                        state.tables[index],
                        state.tables,
                      ));
                    },
                    child: ListTile(
                      onTap: () {},
                      leading: Container(
                        padding: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(
                              color: t.colorScheme.primary)),
                        ),
                        width: 56,
                        height: 40,
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: t.textTheme.headlineSmall?.copyWith(
                              color: t.colorScheme.primary,
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
          return Scaffold(
            appBar: AppBar(title: Text(Strings.appName)),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 56),
                  Text(Strings.error, style: t.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text(Strings.noNet, style: t.textTheme.bodyLarge),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: refresh,
                    icon: const Icon(Icons.refresh),
                    label: Text(Strings.refresh),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(Strings.appName)),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
