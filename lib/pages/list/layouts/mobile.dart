import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/pages/list/functions.dart';
import 'package:logger_app/pages/list/widgets/chart.dart';
import 'package:logger_app/pages/list/widgets/trailing_delete.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/fader.dart';
import 'package:logger_app/widgets/leading.dart';

class MobileList extends StatelessWidget {
  const MobileList({super.key, required this.state});

  final ListLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.itemList.isEmpty) {
      return EmptyList(
        title: state.list.name,
        press: () async => addNewItemDialog(
          context: context,
          list: state.list,
          token: state.token,
        ),
      );
    }

    return Fader(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: LineChart(
            data: state.chartData,
            favourite: state.list.favorite,
          ),
          title: Text(state.list.name),
          scrolledUnderElevation: 0,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(180),
            child: SizedBox(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: favColor(
            favourite: state.list.favorite,
            context: context,
            containerColor: true,
          ),
          onPressed: () async => addNewItemDialog(
            context: context,
            list: state.list,
            token: state.token,
          ),
          icon: const Icon(Icons.add),
          label: Text(Strings.newItemFAB),
        ),
        body: RefreshIndicator(
          color: favColor(favourite: state.list.favorite, context: context),
          onRefresh: () async => refresh(
            context: context,
            list: state.list,
            token: state.token,
          ),
          child: ListView.separated(
            separatorBuilder: (c, i) => const ListDivider(),
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 8 : 0,
                  bottom: i == state.itemList.length - 1 ? 88 : 0,
                ),
                child: ListTile(
                  leading: ListLeading(
                    number: state.itemList[i].number,
                    favourite: state.list.favorite,
                  ),
                  title: Text(dateTitle(state.itemList[i].date)),
                  subtitle: Text(dateSubtitle(state.itemList[i].date)),
                  trailing: ListRemove(index: i, state: state),
                ),
              );
            },
            itemCount: state.itemList.length,
          ),
        ),
      ),
    );
  }
}
