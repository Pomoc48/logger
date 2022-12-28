import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/dismiss_background.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key, required this.index, required this.state});

  final int index;
  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    int rows = state.tables[index].rows;

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
                    rows == 1
                        ? "$rows time"
                        : rows == 0
                            ? "List empty"
                            : "$rows times",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
