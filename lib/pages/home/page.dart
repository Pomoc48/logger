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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Strings.empty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 56+32),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text(Strings.appName)),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, Routes.add),
              icon: const Icon(Icons.add),
              label: Text(Strings.newLog),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(UpdateHome(await getTables()));
              },
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    leading: Container(
                      padding: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(
                            color: Theme.of(context).colorScheme.primary)),
                      ),
                      width: 40+16,
                      height: 40,
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    title: Text(state.tables[index]),
                    subtitle: Text("31 items"),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 0),
                // separatorBuilder: (context, index) => const Divider(),
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
                  Text(
                    Strings.error,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Strings.noNet,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: () async {
                      context.read<HomeBloc>().add(
                        UpdateHome(await getTables()),
                      );
                    },
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
