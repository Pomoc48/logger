import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/pages/list/functions.dart';
import 'package:logger_app/pages/list/widgets/chart.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/dismiss_background.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/fader.dart';
import 'package:logger_app/widgets/leading.dart';

class MobileList extends StatelessWidget {
  const MobileList({super.key, required this.state});

  final ListLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.rowList.isEmpty) {
      return EmptyList(
        title: state.title,
        press: () async => addNewRowDialog(
          context: context,
          name: state.title,
          token: state.token,
        ),
      );
    }

    return Fader(
      child: Scaffold(
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
            token: state.token,
          ),
          icon: const Icon(Icons.add),
          label: Text(Strings.newItemFAB),
        ),
        body: RefreshIndicator(
          onRefresh: () async => refresh(
            context: context,
            name: state.title,
            token: state.token,
          ),
          child: ListView.separated(
            separatorBuilder: (c, i) => const ListDivider(),
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 8 : 0,
                  bottom: i == state.rowList.length - 1 ? 88 : 0,
                ),
                child: Dismissible(
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
                    title: Text(dateTitle(state.rowList[i].date)),
                    subtitle: Text(dateSubtitle(state.rowList[i].date)),
                  ),
                ),
              );
            },
            itemCount: state.rowList.length,
          ),
        ),
      ),
    );
  }
}