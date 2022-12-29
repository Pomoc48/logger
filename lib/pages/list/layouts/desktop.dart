import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/pages/list/functions.dart';
import 'package:logger_app/pages/list/widgets/chart.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/fader.dart';
import 'package:logger_app/widgets/leading.dart';

class DesktopList extends StatelessWidget {
  const DesktopList({super.key, required this.state, required this.width});

  final ListLoaded state;
  final double width;

  @override
  Widget build(BuildContext context) {
    double padding = width > 1200 ? 32 : 24;

    return Fader(
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.list.name),
          scrolledUnderElevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: padding),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 300,
                  maxWidth: 0.25 * width >= 300 ? 0.25 * width : 300,
                ),
                child: ListView.separated(
                  separatorBuilder: (c, i) => const ListDivider(height: 4),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        onTap: () => addNewItemDialog(
                          context: context,
                          list: state.list,
                          token: state.token,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: SizedBox(
                          width: 40,
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(Strings.newItem),
                      );
                    }

                    var i = index - 1;

                    return ListTile(
                      leading: ListLeading(state.itemList[i].number),
                      title: Text(dateTitle(state.itemList[i].timestamp)),
                      subtitle: Text(dateSubtitle(state.itemList[i].timestamp)),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: "delete",
                              child: Text(Strings.delete),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          if (value == "delete") {
                            BlocProvider.of<ListBloc>(context).add(
                              RemoveFromList(
                                item: state.itemList[i],
                                list: state.list,
                                token: state.token,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                  itemCount: state.itemList.length + 1,
                ),
              ),
              SizedBox(width: padding),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: padding * 2,
                    bottom: (padding * 2) + 16,
                    left: padding * 2,
                  ),
                  child: LineChart(data: state.chartData),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
