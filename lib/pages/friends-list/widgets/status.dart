import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/models/friend.dart';
import 'package:logger_app/pages/friends-list/bloc/friends_bloc.dart';
import 'package:logger_app/strings.dart';

class FriendTrailing extends StatelessWidget {
  const FriendTrailing({
    required this.friend,
    required this.token,
    super.key,
  });

  final Friend friend;
  final String token;

  @override
  Widget build(BuildContext context) {
    switch (friend.status) {
      case FriendStatus.pending:
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Opacity(
            opacity: 0.5,
            child: Text(
              Strings.friendPending,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        );
      case FriendStatus.accepted:
        return const SizedBox();
      case FriendStatus.action:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => BlocProvider.of<FriendsBloc>(context).add(
                AcceptFriend(
                  friend: friend,
                  token: token,
                ),
              ),
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () => BlocProvider.of<FriendsBloc>(context).add(
                RemoveFriend(
                  friend: friend,
                  token: token,
                ),
              ),
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ),
          ],
        );
    }
  }
}
