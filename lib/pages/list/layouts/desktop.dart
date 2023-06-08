import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/pages/list/functions.dart';
import 'package:logger_app/pages/list/widgets/chart.dart';
import 'package:logger_app/pages/list/widgets/trailing_delete.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/leading.dart';

class DesktopList extends StatelessWidget {
  const DesktopList({super.key, required this.list, required this.width});

  final ListOfItems list;
  final double width;

  @override
  Widget build(BuildContext context) {
    double padding = width > 1200 ? 32 : 24;

    final listDates = sortItemDates(list.dates);

    return Scaffold(
      appBar: AppBar(
        title: Text(list.name),
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
                        list: list,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: SizedBox(
                        width: 40,
                        child: Icon(
                          Icons.add,
                          color: favColor(
                            favorite: list.favorite,
                            context: context,
                          ),
                        ),
                      ),
                      title: Text(Strings.addNewDate),
                    );
                  }

                  var i = index - 1;

                  return ListTile(
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
                  );
                },
                itemCount: listDates.length + 1,
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
                child: LineChart(
                  data: list.getLongChartData(),
                  favorite: list.favorite,
                ),
              ),
            ),
            SizedBox(width: padding),
          ],
        ),
      ),
    );
  }
}
