import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_app/functions.dart';
import 'package:log_app/pages/list/functions.dart';
import 'package:log_app/widgets/dismiss_background.dart';
import 'package:log_app/pages/list/bloc/list_bloc.dart';
import 'package:log_app/strings.dart';
import 'package:log_app/widgets/empty_list.dart';
import 'package:log_app/widgets/loading.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        ThemeData t = Theme.of(context);

        if (state is ListLoaded) {
          if (state.rowList.isEmpty) {
            return EmptyList(
              title: state.title,
              press: addNewRowDialog,
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text(state.title)),
            floatingActionButton: FloatingActionButton.extended(
              // onPressed: () => addNewRowDialog(context),
              onPressed: () {}, // TODO: add
              icon: const Icon(Icons.add),
              label: Text(Strings.newItemFAB),
            ),
            body: RefreshIndicator(
              onRefresh: () async => refresh(context, state.title),
              child: ListView.separated(
                separatorBuilder: (c, i) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(state.rowList[index].id.toString()),
                    direction: DismissDirection.startToEnd,
                    background: const DismissBackground(),
                    onDismissed: (direction) {
                      context.read<ListBloc>().add(RemoveFromList(
                        rowList: state.rowList,
                        row: state.rowList[index],
                        title: state.title,
                      ));
                    },
                    child: ListTile(
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
                      title: Text(dateTitle(state.rowList[index].date)),
                      subtitle: Text(dateSubtitle(state.rowList[index].date)),
                    ),
                  );
                },
                itemCount: state.rowList.length,
              ),
            ),
          );
        }

        if (state is ListError) {
          return const SizedBox();
        }

        if (state is ListInitial) {
          return PageLoading(title: state.title);
        }

        return PageLoading(title: Strings.appName);
      },
    );
  }
}

