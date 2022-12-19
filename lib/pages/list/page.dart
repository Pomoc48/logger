import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/list/functions.dart';
import 'package:logger_app/pages/list/widgets/chart.dart';
import 'package:logger_app/widgets/dismiss_background.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/leading.dart';
import 'package:logger_app/widgets/loading.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListBloc, ListState>(
      listener: (context, state) {
        if (state is ListError) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is ListLoaded) {
          if (state.rowList.isEmpty) {
            return EmptyList(
              title: state.title,
              press: () async => addNewRowDialog(
                context: context,
                name: state.title,
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              flexibleSpace: LineChart(data: state.chartData),
              title: Text(state.title),
              scrolledUnderElevation: 0,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(180),
                child: SizedBox(),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async => addNewRowDialog(
                context: context,
                name: state.title,
              ),
              icon: const Icon(Icons.add),
              label: Text(Strings.newItemFAB),
            ),
            body: RefreshIndicator(
              onRefresh: () async => refresh(context, state.title),
              child: ListView.separated(
                separatorBuilder: (c, i) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 8 : 0,
                      bottom: index == state.rowList.length - 1 ? 88 : 0,
                    ),
                    child: Dismissible(
                      key: Key(state.rowList[index].id.toString()),
                      direction: DismissDirection.startToEnd,
                      background: const DismissBackground(),
                      onDismissed: (direction) {
                        context.read<ListBloc>().add(RemoveFromList(
                            row: state.rowList[index], title: state.title));
                      },
                      child: ListTile(
                        leading: ListLeading(state.rowList[index].number),
                        title: Text(dateTitle(state.rowList[index].date)),
                        subtitle: Text(dateSubtitle(state.rowList[index].date)),
                      ),
                    ),
                  );
                },
                itemCount: state.rowList.length,
              ),
            ),
          );
        }

        if (state is ListInitial) {
          return PageLoading(title: state.title);
        }

        return PageLoading(title: Strings.appName);
      },
    );
  }
}
