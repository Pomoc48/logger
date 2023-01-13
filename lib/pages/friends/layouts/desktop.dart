// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/friend.dart';
import 'package:logger_app/pages/friends/bloc/friends_bloc.dart';
import 'package:logger_app/pages/friends/functions.dart';
import 'package:logger_app/pages/friends/widgets/status.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/avatar.dart';
import 'package:logger_app/widgets/fader.dart';

class DesktopFriends extends StatelessWidget {
  const DesktopFriends({super.key, required this.state});

  final FriendsLoaded state;

  @override
  Widget build(BuildContext context) {
    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.friends)),
        body: Center(
          child: SizedBox(
            width: 500,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (c, i) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () => addNewFriendDialog(
                      context: context,
                      state: state,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: const Icon(Icons.add),
                    title: Text(Strings.addNewFriend),
                  );
                }

                var i = index - 1;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i == state.friends.length - 1 ? 88 : 0,
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onLongPress: () {
                      if (state.friends[i].status != FriendStatus.action) {
                        deleteFriendDialog(
                          context: context,
                          friend: state.friends[i],
                          token: state.token,
                        );
                      }
                    },
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
                      friend: state.friends[i],
                      token: state.token,
                    ),
                  ),
                );
              },
              itemCount: state.friends.length + 1,
            ),
          ),
        ),
      ),
    );
  }
}
