import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/list/functions.dart';
import 'package:logger_app/pages/list/widgets/chart.dart';
import 'package:logger_app/pages/list/widgets/trailing_delete.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/leading.dart';

class MobileList extends StatelessWidget {
  const MobileList({super.key, required this.list});

  final ListOfItems list;

  @override
  Widget build(BuildContext context) {
    if (list.dates.isEmpty) {
      return EmptyList(
        title: list.name,
        press: () async => addNewItemDialog(
          context: context,
          list: list,
        ),
      );
    }

    final listDates = sortItemDates(list.dates);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: LineChart(
          data: list.getLongChartData(),
          favorite: list.favorite,
        ),
        title: Text(list.name),
        scrolledUnderElevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(180),
          child: SizedBox(),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: favColor(
          favorite: list.favorite,
          context: context,
          containerColor: true,
        ),
        onPressed: () async => addNewItemDialog(
          context: context,
          list: list,
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        separatorBuilder: (c, i) => const ListDivider(),
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(
              top: i == 0 ? 8 : 0,
              bottom: i == listDates.length - 1 ? 128 : 0,
            ),
            child: ListTile(
              leading: ListLeading(
                number: listDates.length - i,
                favorite: list.favorite,
              ),
              title: Text(dateTitle(listDates[i].date)),
              subtitle: Text(dateSubtitle(listDates[i].date)),
              trailing: ListRemove(
                itemId: listDates[i].id,
                listId: list.id,
              ),
            ),
          );
        },
        itemCount: list.dates.length,
      ),
    );
  }
}
