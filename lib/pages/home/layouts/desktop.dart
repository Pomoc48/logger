import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/pages/home/widgets/left_panel.dart';
import 'package:logger_app/pages/home/widgets/quick_insert.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/drawer.dart';
import 'package:logger_app/widgets/menu_item.dart';
import 'package:marquee_widget/marquee_widget.dart';

class DesktopHome extends StatelessWidget {
  const DesktopHome({super.key, required this.state, required this.width});

  final HomeLoaded state;
  final double width;

  @override
  Widget build(BuildContext context) {
    double padding = 24;
    int axis = width > 1400
        ? 3
        : width > 900
            ? 2
            : 1;

    TextTheme tTheme = Theme.of(context).textTheme;
    ColorScheme cScheme = Theme.of(context).colorScheme;

    return DesktopPanel(
      left: const HomeDrawer(desktop: true),
      right: GridView.builder(
        padding: EdgeInsets.all(padding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: axis,
          mainAxisExtent: 162,
          crossAxisSpacing: padding,
          mainAxisSpacing: padding,
        ),
        itemCount: state.lists.length + 1,
        itemBuilder: (context, i) {
          if (i == state.lists.length) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cScheme.primary.withOpacity(0.25),
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () async => addNewListDialog(
                  context: context,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(width: 8),
                    Text(
                      Strings.addNewCounter,
                      style: tTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: favColor(
                  context: context,
                  favorite: state.lists[i].favorite,
                ).withOpacity(0.25),
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () async {
                // BlocProvider.of<ListBloc>(context).add(LoadList(
                //   list: state.lists[i],
                //   token: state.token,
                // ));

                // await Navigator.pushNamed(context, Routes.list);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                      child: LineChart(
                        data: state.lists[i].getChartData(),
                        favorite: state.lists[i].favorite,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuickInsert(
                          listId: state.lists[i].id,
                          favorite: state.lists[i].favorite,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Marquee(
                                forwardAnimation: Curves.easeInOut,
                                animationDuration: Duration(
                                  milliseconds:
                                      (state.lists[i].name.length * 80),
                                ),
                                backDuration: const Duration(milliseconds: 500),
                                backwardAnimation: Curves.easeOutCirc,
                                pauseDuration: const Duration(seconds: 1),
                                child: Text(
                                  state.lists[i].name,
                                  style: tTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                subtitleCount(state.lists[i].dates.length),
                                style: tTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          color: cScheme.secondaryContainer,
                          itemBuilder: (BuildContext context) {
                            return [
                              menuItem(
                                text: Strings.quickAdd,
                                iconData: Icons.bolt,
                                value: "add",
                              ),
                              menuItem(
                                text: getFavButtonString(
                                  favorite: state.lists[i].favorite,
                                ),
                                iconData: Icons.star,
                                value: "favorite",
                              ),
                              menuItem(
                                text: Strings.changeName,
                                iconData: Icons.edit,
                                value: "rename",
                              ),
                              menuItem(
                                text: Strings.removeForever,
                                iconData: Icons.delete,
                                value: "delete",
                              ),
                            ];
                          },
                          onSelected: (value) async {
                            if (value == "add") {
                              quickItem(
                                context: context,
                                listId: state.lists[i].id,
                              );
                            }

                            if (value == "rename") {
                              // renameDialog(
                              //   context: context,
                              //   counterId: state.lists[i].id,
                              //   state: state,
                              //   oldName: state.lists[i].name,
                              // );
                            }

                            if (value == "favorite") {
                              // await updateListFav(
                              //   id: state.lists[i].id,
                              //   favourite: !state.lists[i].favorite,
                              //   token: state.token,
                              // );
                            }

                            if (value == "delete") {
                              // bool delete = await confirmDismiss(
                              //   context: context,
                              //   message: Strings.areSure,
                              // );

                              // if (delete) {
                              //   // ignore: use_build_context_synchronously
                              //   BlocProvider.of<HomeBloc>(context).add(
                              //     RemoveFromHome(
                              //       id: state.lists[i].id,
                              //       state: state,
                              //     ),
                              //   );
                              // }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
