import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/bloc/list_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/pages/home/widgets/quick_insert.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/handle.dart';
import 'package:logger_app/widgets/modal_item.dart';
import 'package:marquee_widget/marquee_widget.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key, required this.state});

  final ListLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.lists.isEmpty) {
      return EmptyList(
        title: Strings.appName,
        press: () async => addNewListDialog(
          context: context,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => showSortingOptions(context),
          ),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async => addNewListDialog(
          context: context,
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        separatorBuilder: (c, i) => const ListDivider(height: 8),
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(
              top: i == 0 ? 8 : 0,
              bottom: i == state.lists.length - 1 ? 128 : 0,
            ),
            child: SizedBox(
              height: 64 + 8,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.only(left: 16, right: 16, top: 4),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.list,
                    arguments: state.lists[i].id,
                  );
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
                            onTap: () => quickItem(
                              context: context,
                              listId: state.lists[i].id,
                            ),
                          ),
                          ModalList(
                            icon: Icons.star,
                            title: getFavButtonString(
                              favorite: state.lists[i].favorite,
                            ),
                            onTap: () {
                              BlocProvider.of<ListBloc>(context).add(
                                ToggleListFavorite(id: state.lists[i].id),
                              );
                            },
                          ),
                          ModalList(
                            icon: Icons.edit,
                            title: Strings.changeName,
                            onTap: () {
                              renameDialog(
                                context: context,
                                listId: state.lists[i].id,
                                oldName: state.lists[i].name,
                              );
                            },
                          ),
                          ModalList(
                            icon: Icons.delete,
                            title: Strings.removeForever,
                            onTap: () async {
                              bool delete = await confirmDelete(
                                context: context,
                                message: Strings.areSure,
                              );

                              if (delete) {
                                // ignore: use_build_context_synchronously
                                BlocProvider.of<ListBloc>(context).add(
                                  RemoveList(id: state.lists[i].id),
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
                  listId: state.lists[i].id,
                  favorite: state.lists[i].favorite,
                ),
                trailing: SizedBox(
                  width: 120,
                  height: 28,
                  child: LineChart(
                    data: state.lists[i].getChartData(),
                    favorite: state.lists[i].favorite,
                  ),
                ),
                title: Marquee(
                  forwardAnimation: Curves.easeInOut,
                  animationDuration: Duration(
                    milliseconds: (state.lists[i].name.length * 80),
                  ),
                  backDuration: const Duration(milliseconds: 500),
                  backwardAnimation: Curves.easeOutCirc,
                  pauseDuration: const Duration(seconds: 1),
                  child: Text(
                    state.lists[i].name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Text(subtitleCount(state.lists[i].dates.length)),
              ),
            ),
          );
        },
        itemCount: state.lists.length,
      ),
    );
  }
}
