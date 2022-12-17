import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_app/pages/home/bloc/home_bloc.dart';
import 'package:log_app/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return Scaffold(
            appBar: AppBar(title: Text(Strings.appName)),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, Routes.add),
              icon: const Icon(Icons.cruelty_free),
              label: Text(Strings.newLog),
            ),
            body: RefreshIndicator(
              onRefresh: () async {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.tables[index]),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: state.tables.length,
                ),
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
                    onPressed: () async {},
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
