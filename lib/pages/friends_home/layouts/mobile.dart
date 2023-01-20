// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:logger_app/pages/friends_home/bloc/friends_home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/fader.dart';

class MobileFriendsHome extends StatelessWidget {
  const MobileFriendsHome({super.key, required this.state});

  final FriendsHomeLoaded state;

  @override
  Widget build(BuildContext context) {
    // if (state.lists.isEmpty) {
    //   return EmptyList(
    //     title: Strings.appName,
    //     press: () async => {},
    //   );
    // }

    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(state.friend.username)),
        body: ListView.separated(
          separatorBuilder: (c, i) => const ListDivider(height: 8),
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.only(
                top: i == 0 ? 8 : 0,
                bottom: i == state.lists.length - 1 ? 88 : 0,
              ),
              child: SizedBox(
                height: 64 + 8,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                  ),
                  trailing: SizedBox(
                    width: 120,
                    height: 28,
                    child: LineChart(
                      data: state.lists[i].chartData,
                      favourite: state.lists[i].favourite,
                    ),
                  ),
                  title: Text(
                    state.lists[i].name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(subtitleCount(state.lists[i].count)),
                ),
              ),
            );
          },
          itemCount: state.lists.length,
        ),
      ),
    );
  }
}
