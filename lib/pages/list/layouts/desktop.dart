import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/pages/list/functions.dart';
import 'package:logger_app/pages/list/widgets/chart.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/dismiss_background.dart';
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
          title: Text(state.title),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 600,
                    maxWidth: 0.4 * width,
                  ),
                  child: Expanded(
                    child: ListView.separated(
                      separatorBuilder: (c, i) => const ListDivider(),
                      itemBuilder: (context, i) {
                        return Dismissible(
                          key: Key(state.rowList[i].id.toString()),
                          direction: DismissDirection.startToEnd,
                          background: const DismissBackground(),
                          onDismissed: (direction) {
                            BlocProvider.of<ListBloc>(context).add(
                              RemoveFromList(
                                row: state.rowList[i],
                                title: state.title,
                                token: state.token,
                              ),
                            );
                          },
                          child: ListTile(
                            leading: ListLeading(state.rowList[i].number),
                            title: Text(dateTitle(state.rowList[i].timestamp)),
                            subtitle: Text(dateSubtitle(state.rowList[i].timestamp)),
                          ),
                        );
                      },
                      itemCount: state.rowList.length,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 300,
                        maxWidth: 0.4 * width,
                      ),
                      child: LineChart(data: state.chartData),
                    ),
                    FloatingActionButton.extended(
                      onPressed: () => addNewRowDialog(
                        context: context,
                        name: state.title,
                        token: state.token,
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(Strings.addNewItem),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
