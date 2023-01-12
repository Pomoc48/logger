// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/friends/bloc/friends_bloc.dart';
import 'package:logger_app/pages/friends/widgets/status.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/avatar.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/fader.dart';

class MobileFriends extends StatelessWidget {
  const MobileFriends({super.key, required this.state});

  final FriendsLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.friends.isEmpty) {
      return Text("empty");
    }

    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.friends)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: Text(Strings.newItemFAB),
        ),
        body: RefreshIndicator(
          onRefresh: () async {},
          child: ListView.separated(
            separatorBuilder: (c, i) => const ListDivider(),
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 8 : 0,
                  bottom: i == state.friends.length - 1 ? 88 : 0,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Avatar(profileUrl: state.friends[i].profileUrl),
                  title: Text(
                    state.friends[i].username,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    dateTitle(state.friends[i].timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: FriendTrailing(
                    friendStatus: state.friends[i].status,
                  ),
                ),
              );
            },
            itemCount: state.friends.length,
          ),
        ),
      ),
    );
  }
}
