import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/actions.dart';
import 'package:logger_app/widgets/dismiss_background.dart';
import 'package:logger_app/widgets/fader.dart';

class DesktopHome extends StatelessWidget {
  const DesktopHome({super.key, required this.state, required this.width});

  final HomeLoaded state;
  final double width;

  @override
  Widget build(BuildContext context) {
    double padding = width > 1200 ? 32 : 24;
    int axis = width > 1200 ? 3 : 2;

    return Fader(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.appName),
          actions: appBarActions(context, state),
        ),
        body: RefreshIndicator(
          onRefresh: () async => refresh(
            context: context,
            token: state.token,
          ),
          child: GridView.builder(
            padding: EdgeInsets.only(
              top: padding,
              left: padding,
              right: padding,
              bottom: padding + 72,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: axis,
              mainAxisExtent: 162,
              crossAxisSpacing: padding,
              mainAxisSpacing: padding,
            ),
            itemBuilder: (context, index) {
              if (index == state.tables.length) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () async => addNewTableDialog(
                      context: context,
                      token: state.token,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        const SizedBox(width: 8),
                        Text(
                          Strings.addNewList,
                          style: Theme.of(context).textTheme.titleMedium,
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
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                    width: 2,
                  ),
                ),
                
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Dismissible(
                    key: Key(state.tables[index].name),
                    direction: DismissDirection.startToEnd,
                    background: const DismissBackground(),
                    confirmDismiss: (d) async => confirmDismiss(
                      context: context,
                      message: Strings.areSure,
                    ),
                    onDismissed: (direction) {
                      BlocProvider.of<HomeBloc>(context).add(
                        RemoveFromHome(
                          table: state.tables[index],
                          tableList: state.tables,
                          token: state.token,
                        ),
                      );
                    },
                    child: InkWell(
                      onTap: () async {
                        BlocProvider.of<ListBloc>(context).add(LoadList(
                          table: state.tables[index],
                          token: state.token,
                        ));
                  
                        await Navigator.pushNamed(context, Routes.list);
                        // ignore: use_build_context_synchronously
                        refresh(context: context, token: state.token);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 70,
                              child: LineChart(data: state.tables[index].chartData),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.tables[index].name,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              subtitleCount(state.tables[index].rows),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: state.tables.length + 1,
          ),
        ),
      ),
    );
  }
}
