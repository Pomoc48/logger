import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/pages/home/widgets/quick_insert.dart';
import 'package:logger_app/pages/home/widgets/sorting.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/dismiss_background.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/drawer.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/fader.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key, required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.lists.isEmpty) {
      return EmptyList(
        title: Strings.appName,
        state: state,
        press: () async => addNewListDialog(
          context: context,
          token: state.token,
        ),
      );
    }

    return Fader(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.appName),
          actions: [Sorting(state: state)],
        ),
        drawer: HomeDrawer(state: state),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async => addNewListDialog(
            context: context,
            token: state.token,
          ),
          icon: const Icon(Icons.add),
          label: Text(Strings.newItemFAB),
        ),
        body: RefreshIndicator(
          onRefresh: () async => refresh(
            context: context,
            token: state.token,
          ),
          child: ListView.separated(
            separatorBuilder: (c, i) => const ListDivider(),
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 8 : 0,
                  bottom: i == state.lists.length - 1 ? 88 : 0,
                ),
                child: Dismissible(
                  key: Key(state.lists[i].name),
                  direction: DismissDirection.startToEnd,
                  background: const DismissBackground(),
                  confirmDismiss: (d) async => confirmDismiss(
                    context: context,
                    message: Strings.areSure,
                  ),
                  onDismissed: (direction) {
                    BlocProvider.of<HomeBloc>(context).add(
                      RemoveFromHome(
                        id: state.lists[i].id,
                        lists: state.lists,
                        token: state.token,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 64 + 8,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 16, right: 16, top: 4),
                      onTap: () async {
                        BlocProvider.of<ListBloc>(context).add(LoadList(
                          list: state.lists[i],
                          token: state.token,
                        ));

                        await Navigator.pushNamed(context, Routes.list);
                        // ignore: use_build_context_synchronously
                        refresh(context: context, token: state.token);
                      },
                      leading: QuickInsert(
                        list: state.lists[i],
                        token: state.token,
                      ),
                      trailing: SizedBox(
                        width: 120,
                        height: 28,
                        child: LineChart(data: state.lists[i].chartData),
                      ),
                      title: Text(
                        state.lists[i].name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(subtitleCount(state.lists[i].count)),
                    ),
                  ),
                ),
              );
            },
            itemCount: state.lists.length,
          ),
        ),
      ),
    );
  }
}
