// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/pages/home/widgets/quick_insert.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/drawer.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/fader.dart';
import 'package:logger_app/widgets/handle.dart';
import 'package:logger_app/widgets/modal_item.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key, required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.lists.isEmpty) {
      return EmptyList(
        title: Strings.appName,
        press: () async => addNewListDialog(
          context: context,
          state: state,
        ),
      );
    }

    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.appName)),
        drawer: HomeDrawer(state: state),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async => addNewListDialog(
            context: context,
            state: state,
          ),
          icon: const Icon(Icons.add),
          label: Text(Strings.newItemFAB),
        ),
        body: RefreshIndicator(
          onRefresh: () async => refresh(
            context: context,
            state: state,
          ),
          child: ListView.separated(
            separatorBuilder: (c, i) => const ListDivider(height: 8),
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 8 : 0,
                  bottom: i == state.lists.length - 1 ? 88 : 0,
                ),
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
                      refresh(context: context, state: state);
                    },
                    onLongPress: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext c) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const DragHandle(),
                              ModalList(
                                icon: Icons.bolt,
                                title: Strings.quickAdd,
                                onTap: () async => quickItem(
                                  context: context,
                                  list: state.lists[i],
                                  state: state,
                                ),
                              ),
                              ModalList(
                                icon: Icons.star,
                                title: getFavButtonString(
                                  favourite: state.lists[i].favourite,
                                ),
                                onTap: () async {
                                  await updateListFav(
                                    id: state.lists[i].id,
                                    favourite: !state.lists[i].favourite,
                                    token: state.token,
                                  );

                                  await refresh(
                                    context: context,
                                    state: state,
                                  );
                                },
                              ),
                              ModalList(
                                icon: Icons.edit,
                                title: Strings.changeName,
                                onTap: () => renameDialog(
                                  context: context,
                                  counterId: state.lists[i].id,
                                  state: state,
                                  oldName: state.lists[i].name,
                                ),
                              ),
                              ModalList(
                                icon: Icons.delete,
                                title: Strings.removeForever,
                                onTap: () async {
                                  bool delete = await confirmDismiss(
                                    context: context,
                                    message: Strings.areSure,
                                  );

                                  if (delete) {
                                    BlocProvider.of<HomeBloc>(context).add(
                                      RemoveFromHome(
                                        id: state.lists[i].id,
                                        state: state,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      );
                    },
                    leading: QuickInsert(
                      list: state.lists[i],
                      state: state,
                      favourite: state.lists[i].favourite,
                    ),
                    trailing: SizedBox(
                      width: 120,
                      height: 28,
                      child: LineChart(
                        data: state.lists[i].chartData,
                        favourite: state.lists[i].favourite,
                      ),
                    ),
                    title: Text(
                      state.lists[i].name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(subtitleCount(state.lists[i].count)),
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
